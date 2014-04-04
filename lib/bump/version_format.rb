module Bump
  class VersionFormat

    def initialize(format)
      @format = format
    end

    def to_regex
      string = @format['format']
      regex = ''
      while true
        i = string.index(/\.|_|-/)
        if i == nil
          regex += get_element_regex(string)
          break
        else
          element_name = string[0...i]
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