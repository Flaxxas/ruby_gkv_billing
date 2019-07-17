module RubyGkvBilling
  module Edifact
    class Payload
      TEST = 0
      TRIAL = 1
      PRODUCTION = 2

      def initialize(
        sender_file, #IK des Absenders
        sender_description, #IK der absendenden Stelle
        receiver_file, # IK des Empfängers
        receiver_description, #IK der empfangenden Stelle
        datenaustausch_ref,  #Fortlaufende Nummer, der Lieferungen zwischen absender und Empfänger.
        service_area, #Leistungserbringer-Sammelgruppenschlüssel siehe 8.1.14.
        anwendungs_ref, #Logischer Dateiname
        created_at: Time.now, # Erstellunszeitpunkt
        testindicator: PRODUCTION #0 wenn Testdatei, 1 wenn Erprobungsdatei, 2 wenn Echtdatei
      )
        @sender_file = sender_file
        @sender_description = sender_description
        @receiver_file = receiver_file
        @receiver_description = receiver_description
        @created_at = created_at
        @datenaustausch_ref = datenaustausch_ref.to_s.rjust(5, "0")[0..4]
        @service_area = service_area
        @anwendungs_ref = anwendungs_ref.to_s.rjust(5, "0")[0..4]
        @testindicator = testindicator

        @message_count = 0
        @messages = []
      end

      def <<(message)
        @message_count += 1
        message.nachrichten_ref_nummer = @message_count
        @messages << message
      end

      def header_segment
        header_segment = RubyGkvBilling::Edifact::Segment.new("UNB")
        header_segment.add_splitted_element(
          [
            "UNOC",
            3
          ]
        )
        header_segment << @sender_file
        header_segment << @sender_description
        header_segment << @receiver_file
        header_segment << @receiver_description
        header_segment.add_splitted_element(
          [
            @created_at.strftime("%Y%m%e"),
            @created_at.strftime("%H%M")
          ]
        )
        header_segment << @datenaustausch_ref
        header_segment << @service_area
        header_segment << @anwendungs_ref
        header_segment << @testindicator

        header_segment
      end

      def footer_segment
        footer_segment = RubyGkvBilling::Edifact::Segment.new("UNZ")
        footer_segment << @message_count
        footer_segment << @datenaustausch_ref

        footer_segment
      end

      def to_edifact
        rows = [header_segment]
        rows += @messages
        rows << footer_segment

        rows.map(&:to_edifact).join("\n")
      end
    end
  end
end
