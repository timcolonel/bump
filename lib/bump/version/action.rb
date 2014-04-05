module Bump
  module Version
    class Action
      attr_accessor :name
      attr_accessor :type
      attr_accessor :optional
      attr_accessor :value


      def initialize(name, hash)
        @name = name
        init(hash)
      end

      def to_regex
        case @type
          when 'int'
            '[0-9]+'
          else
            @type.split(',').join('|')
        end
      end

      def init(value)
        if value.is_a? String
          @type = value
          @optional = false
        else
          @type = value['type']
          @optional = !!element['optional']
        end
      end

      def bump(operation=1)
        @value = get_bump_value(operation)
      end

      def get_bump_value(operation = 1)
        case @type
          when 'int'
            @value.to_i + operation
          else #(a,b,rc,r) format for example
            array = @type.split(',')[0]
            if @value.nil?
              array[0]
            else
              i = array.index(@value)
              if i < array.size
                array[i]
              else #Reach the end of possibilities
                raise Error, "No more option to bump this action #{@name} with values #{@type}"
              end
            end

        end
      end

      def self.parse(actions_hash)
        actions = {}
        actions_hash.each do |k, v|
          actions[k]= Bump::Version::Action.new(k, v)
        end
        actions
      end

      def optional?
        @optional
      end

      def get_default_value
        if optional?
          return nil
        end

        case @type
          when 'int'
            0
          else #(a,b,rc,r) format for example
            @type.split(',')[0]
        end
      end
    end
  end
end