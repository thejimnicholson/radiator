require 'resolv'
require 'open-uri'

class Client
  include DataMapper::Resource
  property :ip, IPAddress, :key => true
  property :host, String
  property :location, String

  def lookup_host(name)
    return self.host unless host.nil?
    unless name.nil?
       self.host = name
       return self.host
     end
    begin
      self.host = Resolv.new.getname(ip.to_s)
    rescue Resolv::ResolvError
      self.host = nil
    end
    self.host
  end


  def self.find_or_create_by_ip(target)
    this_one = self.get(target)
    if  this_one.nil?
      this_one = self.create()
      this_one.ip = target
    end
    this_one
  end

end

class Source
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :href, URI
  property :frequency,  Integer

  def current_data
    JSON.parse(open(href).read)
  end

end

DataMapper.finalize
