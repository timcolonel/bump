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

      attr_accessor :version_string

      attr_accessor :version_format

      def data_dir
        "#{File.dirname(__FILE__)}/../../data"
      end

      def template_dir
        "#{File.dirname(__FILE__)}/../../template"
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
        if @version_regex.nil?
          load_version_regex
        end

        load_version_string

        load_version_format
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
          results = Dir.glob(filename)
          if results.size > 0
            puts "Using version file: #{results[0]}"
            @version_filename = results[0]
            return
          end
        end
        raise Bump::Error, 'Unable to find the version file(Please specify in the config)'
      end

      def load_version_regex
        content = File.open(@version_filename).read
        load_file(File.join(data_dir, 'version_formats.yml')).each do |key, format|
          if content.match(format)
            puts "Using version format #{key}"
            @version_regex = Regexp.new(format)
            return
          end
        end

        raise Bump::Error, "Unable to find the version variable in the file #{@version_filename} (Please specify in the config)"
      end

      def load_version_string
        content = File.open(@version_filename).read
        @version_string = content.scan(@version_regex)[0][1]
      end

      def load_version_format
        formats = Bump::Config.load_file(File.join(Bump::Config.data_dir, 'version_conventions.yml'))
        formats.each do |format_name, format_hash|
          format = Bump::Version::Format.new(format_hash)
          if format.parse(@version_string)
            puts "Using version convention #{format_name}"
            @version_format = format
            return
          end
        end

        raise Bump::Error, "Format not found for version #{@version_string} (Please specify in config)"
      end

      def load_file(filename)
        YAML.load_file(filename)
      end
    end
  end
end