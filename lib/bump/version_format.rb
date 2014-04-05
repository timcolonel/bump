module Bump
  class VersionFormat
    DELIMITER_REGEXP= /\.|_|-/

    def initialize(format)
      @format = format
      @elements = []
      @values = {}
    end

    def parse(version_str)
      @version_str = version_str
      return false unless @version_str.match(to_regex)
      match
      puts @values
      true
    end

    def match
      version_array = @version_str.split(DELIMITER_REGEXP)
      format_array = @format['format'].split(DELIMITER_REGEXP)
      version_array.each_with_index do |element_name, i|
        format_name = format_array[i]
        @values[format_name] = element_name
      end
    end

    def to_regex
      string = @format['format']
      regex = ''
      while true
        i = string.index(DELIMITER_REGEXP)
        if i == nil
          regex += get_element_regex(string)
          break
        else
          element_name = string[0...i]
          @elements << element_name
          delimiter = string[i]
          regex += get_element_regex(element_name)
          regex += get_delimiter_regex(delimiter)
          string = string[i+1..-1]
        end
      end
      regex
    end

    def get_element_regex(element_name)
      type_regex = get_type_regex(get_type(element_name))
      if element_optional?(element_name)
        type_regex = "(#{type_regex})?"
      end
      type_regex
    end

    def element_optional?(element_name)
      element = @format['action'][element_name]
      if element.is_a? Hash
        !!element['optional']
      else
        false
      end
    end

    def get_type(element_name)
      element = @format['action'][element_name]
      if element.is_a? String
        element
      else
        element['type']
      end
    end

    def get_type_regex(type)
      case type
        when 'int'
          '[0-9]+'
        else
          type.split(',').join('|')
      end
    end

    def get_delimiter_regex(delimiter)
      case delimiter
        when '.'
          '\.'
        when '-'
          '\-'
        when '_'
          ''
        else
          raise Error, "Unkwown delimiter '#{delimiter}'"
      end
    end
  end
end