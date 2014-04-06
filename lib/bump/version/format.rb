module Bump
  module Version
    class Format
      DELIMITER_REGEXP= /\.|_|-/

      def initialize(format)
        @format = format
        @actions = Bump::Version::Action.parse(@format['action'])
        @elements= []
        parse_format
      end

      def parse_format
        string = @format['format']
        while true
          i = string.index(DELIMITER_REGEXP)
          if i == nil
            @elements << @actions[string]
            break
          else
            element_name = string[0...i]
            delimiter = string[i]

            @elements << @actions[element_name]
            @elements << delimiter
            string = string[i+1..-1]
          end
        end
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
        format_array = @format['format'].split(DELIMITER_REGEXP)
        format_array[format_array.index(action_name)+1..-1].each do |following_action_name|
          following_action = @actions[following_action_name]
          following_action.reset
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
        regex = ''
        i = 0
        while i < @elements.size
          action = @elements[i]
          regex += action.to_regex
          if i+1 < @elements.size
            optional = false
            if i+2 < @elements.size and @elements[i+2].optional?
              optional = true
            end

            delimiter = @elements[i+1]
            regex += get_delimiter_regex(delimiter, optional)
          end
          i += 2
        end
        "^#{regex}$"
      end

      def to_s
        output = ''
        i=0
        while i < @elements.size
          action = @elements[i]
          output += action.value.to_s
          if i+1 < @elements.size
            unless i+2 < @elements.size and @elements[i+2].value.nil?
              delimiter = @elements[i+1]
              output += delimiter
            end
          end
          i += 2
        end
        output
      end


      def get_delimiter_regex(delimiter, optional = false)
        output = ''
        case delimiter
          when '.'
            output = '\.'
          when '-'
            output = '\-'
          when '_'
            output = ''
          else
            raise Error, "Unkwown delimiter '#{delimiter}'"
        end
        if optional
          output = "(#{output})?"
        end
        output
      end
    end
  end
end