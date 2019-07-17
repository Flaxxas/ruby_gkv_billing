module RubyGkvBilling
  module Edifact
    class Segment
      def initialize(name, initial_elements: [])
        @elements = []
        @name = name

        self.<<(@name)

        initial_elements.each do |element|
          self.<<(element)
        end
      end

      def <<(element)
        @elements << convert(element)
      end

      def convert(element)
        #code
      end

      def elements
        @elements
      end

      def to_edifact
        @elements.join(RubyGkvBilling::Edifact::DATA_DIVIDE_CHAR) +
        "#{RubyGkvBilling::Edifact::SEGMENT_END_CHAR}"
      end
    end
  end
end
