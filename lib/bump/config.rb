require 'yaml'

module Bump
  module Config

    CONFIG_FILE = 'bump.yml'
    class << self
      #Application main language
      attr_accessor :language
      #Path to the file containing the version variable
      attr_accessor :version_filename
      #Regex for the format the version is in the file
      attr_accessor :version_regex

      attr_accessor :local_config

      def data_dir
        "#{File.dirname(__FILE__)}/../../data"
      end

      def load_config
        @language = nil
        @version_filename = nil
        @version_regex = nil

        load_local_config
        if @language.nil?
          @language = 'ruby'
        end
        if @version_filename.nil?
          load_filename
        end
      end

      def load_local_config
        if File.exists?(CONFIG_FILE)
          @local_config = load_file(CONFIG_FILE)
          @language = @local_config['language']
          @version_filename = @local_config['version_filename']
          @version_regex = @local_config['version_regex']
        end
      end

      def load_filename
        languages = load_file(File.join(data_dir, 'version_filenames.yml'))
        filenames = languages[@language] + languages['all']
        filenames.each do |filename|
          puts 'Trying bullshit: '+ filename + ' -- ' + Dir.glob(filename).to_s
          results = Dir.glob(filename).size > 0
          if results.size > 0
            puts "Using: #{result[0]}"
            @version_filename = result[0]
          end
        end
        puts 'noediojio'
      end

      def load_file(filename)
        YAML.load_file(filename)
      end
    end
  end
end