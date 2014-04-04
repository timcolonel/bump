require_relative 'bump/config'
require_relative 'bump/error'

module Bump
  class << self
    def run
      Bump::Config.version_filename = '../rails_embed_editor/lib/rails_embed_editor/version.rb'
      Bump::Config.version_regex = /(VERSION = ')(.*)(')/
      if File.open(Bump::Config.version_filename).read.match(Bump::Config.version_regex)
        puts 'MATCHING'
      end
      Bump::Config.load_config
      #update_version('0.0.2')
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