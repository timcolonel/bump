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
            puts 'NII'
          when 'current'
            current
          else
            Bump::Config.version_format.bump(action)
            puts Bump::Config.version_format
        end

      end

      #update_version('0.0.3')
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

Bump.run