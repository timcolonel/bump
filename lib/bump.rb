require 'fileutils'

require_relative 'bump/config'
require_relative 'bump/error'
require_relative 'bump/version/format'
require_relative 'bump/version/action'

module Bump
  class << self
    def run
      Bump::Config.load_config
      action = ARGV[0]
      unless action.nil?
        case action
          when 'init'
            init
          when 'current'
            current
          else
            Bump::Config.version_format.bump(action)
            update_version Bump::Config.version_format.to_s
            puts "Bumped to version '#{Bump::Config.version_format}'"
        end

      end
    end

    #Copy the local config file to the root of the project
    def init
      FileUtils.cp File.join(Bump::Config.template_dir, Bump::Config::CONFIG_FILE), Bump::Config::CONFIG_FILE
      puts "Local config file #{Bump::Config::CONFIG_FILE} created!"
    end

    #Show the current version
    def current
      puts Bump::Config.version_format
    end

    def update_version(new_version)
      change = File.open(Bump::Config.version_filename).read.gsub(Bump::Config.version_regex, '\1'+ new_version+'\3')
      File.open(Bump::Config.version_filename, 'w') do |file|
        file.write(change)
      end
    end
  end
end


if __FILE__ == $0
  Bump.run
end