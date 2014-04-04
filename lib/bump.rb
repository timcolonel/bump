require './lib/bump/config'
module Bump
  class << self
    def run
      Bump::Config.version_path = '../rails_embed_editor/lib/rails_embed_editor/version.rb'
      Bump::Config.version_regex = /(VERSION = ')(.*)(')/
      puts 'Scan: ' + File.open(Bump::Config.version_path).read.scan(Bump::Config.version_regex).to_s
      puts 'Scan: ' + File.open(Bump::Config.version_path).read.gsub(Bump::Config.version_regex, '\1replace_text\3').to_s
    end


  end
end

Bump.run