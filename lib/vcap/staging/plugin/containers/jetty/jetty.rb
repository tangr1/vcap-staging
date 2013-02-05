require 'nokogiri'
require 'fileutils'

class Jetty

  def self.resource_dir
    File.join(File.dirname(__FILE__), 'resources')
  end

  def self.prepare(dir)
    runner = File.join(resource_dir, "jetty-runner.jar")
    FileUtils.cp_r(runner, dir)
    webapp_path = File.join(dir, "app")
    FileUtils.mkdir_p(webapp_path)
    webapp_path
  end

  def self.insight_bound? services
    services.any? { |service| service if service[:name] =~ /^Insight-.*/ and service[:label] =~ /^rabbitmq-*/ } if services #
  end

  def self.prepare_insight dir, environment, agent=nil
  end

  def self.start_command
    "%VCAP_LOCAL_RUNTIME% -jar ./jetty-runner.jar ./app"
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
