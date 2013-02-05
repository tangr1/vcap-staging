require 'nokogiri'
require 'fileutils'

class Jboss

  def self.resource_dir
    File.join(File.dirname(__FILE__), 'resources')
  end

  def self.prepare(dir)
    FileUtils.cp_r(resource_dir, dir)
    output = %x[cd #{dir}; unzip -q resources/jboss.zip]
    raise "Could not unpack Jboss: #{output}" unless $? == 0
    webapp_path = File.join(dir, "jboss", "standalone", "deployments", "app.war")
    FileUtils.rm(File.join(dir, "resources", "jboss.zip"))
    FileUtils.mkdir_p(webapp_path)
    FileUtils.touch(File.join(webapp_path, "app.war.dodeploy"))
    webapp_path
  end

  def self.insight_bound? services
    services.any? { |service| service if service[:name] =~ /^Insight-.*/ and service[:label] =~ /^rabbitmq-*/ } if services #
  end

  def self.prepare_insight dir, environment, agent=nil
  end

  def self.start_command
    "./jboss/bin/standalone.sh"
  end

  def self.change_directory_for_start
  end

  def self.env_vars
    vars = {}
    vars
  end

  def self.startup_script
    <<-JAVA
    JAVA
  end

end
