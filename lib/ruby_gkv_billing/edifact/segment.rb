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
        string = element.to_s

        string.gsub!(RubyGkvBilling::Edifact::REPLACE_CHAR, "#{RubyGkvBilling::Edifact::REPLACE_CHAR}#{RubyGkvBilling::Edifact::REPLACE_CHAR}")
        string.gsub!(RubyGkvBilling::Edifact::ELEMENT_DIVIDE_CHAR, "#{RubyGkvBilling::Edifact::REPLACE_CHAR}#{RubyGkvBilling::Edifact::ELEMENT_DIVIDE_CHAR}")
        string.gsub!(RubyGkvBilling::Edifact::DATA_DIVIDE_CHAR, "#{RubyGkvBilling::Edifact::REPLACE_CHAR}#{RubyGkvBilling::Edifact::DATA_DIVIDE_CHAR}")
        string.gsub!(RubyGkvBilling::Edifact::DECIMAL_CHAR, "#{RubyGkvBilling::Edifact::REPLACE_CHAR}#{RubyGkvBilling::Edifact::DECIMAL_CHAR}")
        string.gsub!(RubyGkvBilling::Edifact::SEGMENT_END_CHAR, "#{RubyGkvBilling::Edifact::REPLACE_CHAR}#{RubyGkvBilling::Edifact::SEGMENT_END_CHAR}")

        if element.is_a?(Float)
          string.gsub!(".", ",")
        end
        
        string.gsub!(" ", ":")

        string
      end

      def elements
        @elements
      end

      def to_edifact
        @elements.join(RubyGkvBilling::Edifact::ELEMENT_DIVIDE_CHAR) +
        "#{RubyGkvBilling::Edifact::SEGMENT_END_CHAR}"
      end
    end
  end
end
