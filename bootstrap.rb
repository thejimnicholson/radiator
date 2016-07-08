puts "Reinitializing database..."

Source.destroy!

Source.new(
  "name" => "jenkins-ci.org",
  "href" => "https://ci.jenkins-ci.org/api/json?depth=1",
  "frequency" => 1,
  "format" => "Jenkins 2.0"
).save!

Source.new(
  "name" => "local jenkins",
  "href" => "http://127.0.0.1:8080/api/json?tree=jobs[name,url,color]",
  "frequency" => 1,
  "format" => "Jenkins"
).save!

Source.new(
  "name" => "Radiator on travis/ci",
  "href" => "https://api.travis-ci.org/repos/thejimnicholson/radiator/builds",
  "frequency" => 1,
  "format" => "Travis"
).save!
Source.new(
  "name" => "Addteq Jenkins",
  "href" => "https://jenkins.addteq.com/api/json/?tree=jobs[name,url,color]",
  "frequency" => 1,
  "format" => "Jenkins"
).save!

puts "Done."



