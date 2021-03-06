require 'fileutils'
require 'apache/config'
require 'apache/rake/create'
require 'yaml'
require 'rainbow'

namespace :apache do
  desc "Create all defined configs for the specified environment"
  task :create, :environment do |t, args|
    APACHE_ENV = (args[:environment] || 'production').to_sym

    CONFIG = Hash[YAML.load_file('config.yml').collect { |k,v| [ k.to_sym, v ] }]

    CONFIG[:source_path] = File.expand_path(CONFIG[:source])
    CONFIG[:dest_path] = File.expand_path(CONFIG[:destination])

    Apache::Config.rotate_logs_path = CONFIG[:rotate_logs_path]

    FileUtils.mkdir_p CONFIG[:dest_path]
    Dir.chdir CONFIG[:dest_path]

    Dir[File.join(CONFIG[:source_path], '**', '*.rb')].each do |file|
      puts file.foreground(:green)
      require file
    end
  end
end
