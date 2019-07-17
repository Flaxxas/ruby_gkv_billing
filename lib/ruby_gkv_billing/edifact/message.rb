module RubyGkvBilling
  module Edifact
    class Message

      def initialize(nachrichten_ref_nummer, nachricht_kennung, segments: [])
        @segments = segments
        self.nachrichten_ref_nummer = nachrichten_ref_nummer
        @nachricht_kennung = nachricht_kennung.to_s[0..3]
      end

      def nachrichten_ref_nummer=(value)
        @nachrichten_ref_nummer = value.to_s.rjust(5, "0")[0..4]
      end

      def nachrichten_ref_nummer
        @nachrichten_ref_nummer
      end

      def <<(segment)
        @segments << segment
      end

      def header_segment
        header_segment = RubyGkvBilling::Edifact::Segment.new("UNH")
        header_segment << @nachrichten_ref_nummer
        header_segment.add_splitted_element(
          [
            @nachricht_kennung,
            RubyGkvBilling::Edifact::MESSAGE_VERSION,
            0,
            0
          ]
        )

        header_segment
      end

      def footer_segment
        footer_segment = RubyGkvBilling::Edifact::Segment.new("UNT")
        footer_segment << (@segments.size + 2)
        footer_segment << @nachrichten_ref_nummer

        footer_segment
      end

      def to_edifact
        rows = [header_segment]
        rows += @segments
        rows << footer_segment

        rows.map(&:to_edifact).join("\n")
      end
    end
  end
end
