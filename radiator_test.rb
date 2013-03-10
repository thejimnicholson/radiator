#!/usr/bin/env ruby
ENV['RACK_ENV'] = 'test'
require './radiator.rb'

class RadiatorTest <  Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Radiator
  end

  def setup
    @client = client_for_tests
  end

  def teardown
    Client.all.each {|c| c.destroy }
  end

  def test_naked_get
    get '/'
    assert last_response.ok?
  end

  def test_client_find_or_create_by_ip_for_new
    client = Client.find_or_create_by_ip('127.0.0.2')
    assert !client.nil?, 'should return a new client'
    assert_equal('127.0.0.2', client.ip.to_s, 'should set ip address')
  end

  def test_client_find_or_create_by_ip_for_existing
    client2 = Client.find_or_create_by_ip('127.0.0.1')
    assert_equal(@client,client2,'Should get the same client')
  end

  def test_client_lookup_host_no_value
    flexmock(Resolv).new_instances.should_receive(:getname => 'localhost')
    assert_equal('localhost',@client.lookup_host(nil),'should be localhost')
  end

  def test_client_lookup_host_has_value
    @client.host = nil
    @client.save
    assert_equal('somevalue',@client.lookup_host('somevalue'),'should be somevalue')
  end

  def test_source_current_data
    FakeWeb.register_uri(:get, "http://127.0.0.1:9999/foo", :body => JSON::dump({:heres => "some json"}))
    source = Source.new(:name => 'test', :href=> 'http://127.0.0.1:9999/foo',:frequency => 1)

    assert_nothing_raised do 
      assert_equal({'heres' => "some json"},source.current_data, "Something amiss: #{source.current_data.inspect}")
    end
  end


  def client_for_tests
    client = Client.create(:location => 'test')
    client.ip = '127.0.0.1'
    client.save
    client
  end

end
