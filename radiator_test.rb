#!/usr/bin/env ruby
ENV['RACK_ENV'] = 'test'
require './radiator.rb'

class RadiatorTest <  Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Radiator
  end

  def setup
    flexmock(Resolv).new_instances.should_receive(:getname => 'localhost')
    @client = client_for_tests
  end

  def teardown
    Client.all.each {|c| c.destroy! }
    View.all.each {|v| v.destroy! }
    Source.all.each {|s| s.destroy! }
  end

  def test_get_existing_client
    get '/',{}
    assert last_response.ok?
  end

  def test_get_unknown_ip
    get '/', {}, { 'REMOTE_ADDR' => '127.0.0.2' }
    assert last_response.ok?
    assert !Client.get('127.0.0.2').nil?, 'Should have created a record'
  end

  def test_get_views
    get '/views',{}
    assert last_response.ok?
    parsing(last_response.body) do |html|
      assert_equal(2,html.css('div.job').length,'should have two jobs')
      assert(html.css('div.job.red').text =~ /failjob/, 'failjob should render red')
      assert(html.css('div.job.blue').text =~ /goodjob/, 'goodjob should render blue')
    end
  end

  def test_get_configure
    get '/configure', {}
    assert last_response.ok?
    parsing(last_response.body) do |html|
      assert_equal(2,html.css('#sources input').length,'Should have two view')
    end
  end

  def test_client_find_or_create_by_ip_for_new
    client = Client.find_or_create_by_ip('127.0.0.2')
    client.save!
    assert !client.nil?, 'should return a new client'
    assert_equal('127.0.0.2', client.ip.to_s, 'should set ip address')
    assert !Client.get('127.0.0.2').nil?, 'Should have created a record'
  end

  def test_client_find_or_create_by_ip_for_existing
    client2 = Client.find_or_create_by_ip('127.0.0.1')
    assert_equal(@client,client2,'Should get the same client')
  end

  def test_client_lookup_host_no_value
    assert_equal('localhost',@client.lookup_host(nil),'should be localhost')
  end

  def test_client_lookup_host_has_forced_value
    @client.host = nil
    @client.save
    assert_equal('somevalue',@client.lookup_host('somevalue'),'should be somevalue')
  end

  def test_source_current_data
    FakeWeb.register_uri(:get, "http://127.0.0.1:9999/for", :body => JSON::dump({:heres => "some json"}))
    source = Source.new(:name => 'test', :href=> 'http://127.0.0.1:9999/for',:frequency => 1)
    assert_nothing_raised do 
      assert_equal({'heres' => "some json"},source.current_data, "Something amiss: #{source.current_data.inspect}")
    end
  end

  def test_view_jobs
    assert @client.view.jobs.length == 2
  end

  def client_for_tests
    FakeWeb.register_uri(:get, "http://127.0.0.1:9999/foo", :body => JSON::dump({"jobs"=>[{"color"=>"red", "url"=>"http://localhost:8080/job/failjob/", "name"=>"failjob"}]}))
    FakeWeb.register_uri(:get, "http://127.0.0.1:9998/bar", :body => JSON::dump({"jobs"=>[{"color"=>"blue", "url"=>"http://localhost:8080/job/goodjob/", "name"=>"goodjob"}]}))
    client = Client.create(:location => 'test')
    client.ip = '127.0.0.1'
    client.save!
    source1 = Source.create(:name => 'test', :href=> 'http://127.0.0.1:9999/foo', :frequency => 1)
    source2 = Source.create(:name => 'test2', :href=> 'http://127.0.0.1:9998/bar',:frequency => 1)
    view = View.create(:title => 'A view')
    view.sources << source1
    view.sources << source2
    view.save!
    client.view = view
    client.save!
    client
  end

  def parsing(body,&block)
    tree = Nokogiri::HTML(body)
    yield tree
  end

end
