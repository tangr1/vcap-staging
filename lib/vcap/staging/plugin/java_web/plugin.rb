require File.expand_path('../../staging_plugin', __FILE__)

class JavaWebPlugin < StagingPlugin

  include JavaDatabaseSupport
  include JavaAutoconfig

  def framework
    'java_web'
  end

  def autostaging_template
    nil
  end

  def skip_staging webapp_root
    true
  end

  def stage_application
    Dir.chdir(destination_directory) do
      create_app_directories
      webapp_root = @container_klass.prepare(destination_directory)
      copy_source_files(webapp_root)
      web_config_file = File.join(webapp_root, 'WEB-INF/web.xml')
      unless File.exist? web_config_file
        raise "Web application staging failed: web.xml not found"
      end
      services = environment[:services] if environment
      copy_service_drivers(File.join(webapp_root,'../../lib'), services)
      @container_klass.prepare_insight destination_directory, environment, insight_agent if @container_klass.insight_bound? services
      configure_webapp(webapp_root, self.autostaging_template, environment) unless self.skip_staging(webapp_root)
      create_startup_script
      create_stop_script
    end
  end

  # The driver from which all of the staging modifications are made for Java based plugins [java_web, spring,
  # grails & lift]. Each framework plugin overrides this method to provide the implementation it needs.
  # Modifications needed by the implementations that are common to one or more plugins are provided
  # by the Tomcat class used by all of the Java based plugins. E.g are the updates for autostaging context_param,
  # autostaging servlet [both needed by 'spring' & 'grails'] & copying the autostaging jar ['spring', 'grails' &
  # 'lift'].
  def configure_webapp webapp_root, autostaging_template, environment
  end

  def create_app_directories
    FileUtils.mkdir_p(log_dir)
    FileUtils.mkdir_p(tmp_dir)
  end

  def change_directory_for_start
    @container_klass.change_directory_for_start
  end

  def start_command
    @container_klass.start_command
  end

  private

  def startup_script
    generate_startup_script(@container_klass.env_vars) do
      @container_klass.startup_script
    end
  end

  def stop_script
    generate_stop_script
  end
end
