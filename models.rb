require 'resolv'
require 'open-uri'

class Client
  include DataMapper::Resource
  property :ip, IPAddress, :key => true
  property :host, String
  property :location, String
  has 1, :view

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
      this_one.view = View.new
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
  has n, :views, :through => Resource
  def current_data
    JSON.parse(open(href).read)
  end

end

class View
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :filter_aborted, Boolean
  property :filter_active, Boolean
  property :filter_disabled, Boolean
  property :filter_failed, Boolean
  property :filter_succeeded, Boolean
  property :filter_unstable, Boolean
  belongs_to :client
  has n, :sources , :through => Resource

  def jobs
    all_jobs = sources.collect {|s| s.current_data['jobs']}.flatten
    all_jobs.select {|job| filters.any? {|filter| filter.match(job['color'])}}
  end

  def filters
    f = []
    f << /aborted/ if filter_aborted
    f << /.*_anime/ if filter_active
    f << /disabled/ if filter_disabled
    f << /red/ if filter_failed
    f << /blue/ if filter_succeeded
    f << /yellow/ if filter_unstable
    f
  end

  def reset_filters
    [:filter_aborted=,:filter_active=,:filter_disabled=,:filter_failed=,:filter_succeeded=,:filter_unstable=].each do |f|
      self.send(f,nil)
    end
    self
  end
end


DataMapper.finalize
