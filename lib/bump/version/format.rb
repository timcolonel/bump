module Bump
  module Version
    class Format
      DELIMITER_REGEXP= /\.|_|-/

      def initialize(format)
        @format = format
        @actions = Bump::Version::Action.parse(@format['action'])
      end


      def parse(version_str)
        @version_str = version_str
        return false unless @version_str.match(to_regex)
        map
      end

      #Map values to the format
      def map
        version_array = @version_str.split(DELIMITER_REGEXP)
        format_array = @format['format'].split(DELIMITER_REGEXP)
        version_array.each_with_index do |element_name, i|
          format_name = format_array[i]
          @actions[format_name].value = element_name
        end
      end

      def bump(action_name, operation = 1)
        action = @actions[action_name]
        if action.nil?
          raise Error, "Error unknown action #{element_name}"
        end
        action.bump(operation)
      end

      def upgrade(action)
        bump(action, 1)
      end

      def downgrade(action)
        bump(action, -1)
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
            delimiter = string[i]
            regex += get_element_regex(element_name)
            regex += get_delimiter_regex(delimiter)
            string = string[i+1..-1]
          end
        end
        regex
      end

      def to_s
        string = @format['format']
        output = ''
        while true
          i = string.index(DELIMITER_REGEXP)
          if i == nil
            output += @actions[string].value.to_s
            break
          else
            element_name = string[0...i]
            delimiter = string[i]
            output += @actions[element_name].value.to_s
            output += delimiter
            string = string[i+1..-1]
          end
        end
        output
      end

      def get_element_regex(element_name)
        action = @actions[element_name]
        type_regex = action.to_regex
        if action.optional?
          type_regex = "(#{type_regex})?"
        end
        type_regex
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
end