require_relative 'bump/config'
require_relative 'bump/error'
require_relative 'bump/version_format'

module Bump
  class << self
    def run
      Bump::Config.load_config
      update_version('0.0.3')
    end


    def update_version(new_version)
      change = File.open(Bump::Config.version_filename).read.gsub(Bump::Config.version_regex, '\1'+ new_version+'\3')
      puts 'Chanching: '
      puts change
      File.open(Bump::Config.version_filename, 'w') do |file|
        file.write(change)
      end
    end
  end
end

Bump.run