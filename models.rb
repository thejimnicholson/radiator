require 'resolv'
require 'open-uri'

class Client
  include DataMapper::Resource
  property :ip, IPAddress, :key => true
  property :host, String
  property :location, String
  has 1, :view

  

  def lookup_host(name)
    return host unless host.nil?
    unless name.nil?
       host = name
       return host
     end
    begin
      host = Resolv.new.getname(ip.to_s)
    rescue Resolv::ResolvError
      host = nil
    end
    host
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
  property :frequency,  Integer, :default => 60
  property :format, String

  attr_reader :data
  attr_reader :last_poll

  has n, :views, :through => Resource

  def raw_data
    if @data.nil? || @last_poll.nil? || (@last_poll + frequency) < Time.now
      @last_poll = Time.now
      @data = open(href).read
    end
    return @data
  end


  def current_data
    JSON.parse(raw_data)
  end

  def parsed_data
     travis_status_map = {0 => 'blue', 1=> 'red', 'nil' => 'disabled'} 
    case format
    when "Jenkins"
      return current_data['jobs'].flatten
      exit
    when "Travis"
      jobs = current_data.first
      jobs['name'] = name
      
      jobs['url'] = href.to_s.gsub(/https:\/\/api.travis-ci.org\/repos/,"https://travis-ci.org") + "/" + current_data.first['id'].to_s
      jobs['color'] = travis_status_map[jobs['result']]
      return [jobs]
    when "Jenkins 2.0"
      jobs = current_data['jobs'].collect {|j| j['jobs']}.flatten
    else
      jobs = []
    end
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
    all_jobs = []
    sources.each do |s|
      all_jobs << s.parsed_data.flatten
    end
    all_jobs.flatten.select {|job| filters.any? {|filter| filter.match(job['color'])}}
    #all_jobs
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
