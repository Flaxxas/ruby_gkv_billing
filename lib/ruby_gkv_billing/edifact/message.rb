require "ruby_gkv_billing/edifact/message/slga"
require "ruby_gkv_billing/edifact/message/slla"
require "ruby_gkv_billing/edifact/message/slla/inv"
require "ruby_gkv_billing/edifact/message/slla/other"
require "ruby_gkv_billing/edifact/message/slla/medicine"

module RubyGkvBilling
  module Edifact
    class Message
      #nachrichten_ref_nummer: fortlaufende Nummer der UNH-segmente
      #zwischen UNB und UNZ
      def initialize(nachrichten_ref_nummer, nachricht_kennung, segments: [], message_version: RubyGkvBilling::Edifact::MESSAGE_VERSION)
        @segments = segments
        self.nachrichten_ref_nummer = nachrichten_ref_nummer
        @nachricht_kennung = nachricht_kennung.to_s[0..3]

        @message_version = message_version
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
            @message_version,
            0,
            0
          ]
        )

        header_segment
      end

      def footer_segment
        footer_segment = RubyGkvBilling::Edifact::Segment.new("UNT")
        size = (@segments.size + 2)
        footer_segment << size.to_s.rjust(6, "0")
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
