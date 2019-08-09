module RubyGkvBilling
  module Edifact
    class Payload
      TEST = 0
      TRIAL = 1
      PRODUCTION = 2

      def initialize(
        absender_datei, #IK des Absenders
        absender_bezeichnung, #IK der absendenden Stelle
        empfaenger_datei, # IK des Empfängers
        empfaenger_bezeichnung, #IK der empfangenden Stelle
        datenaustausch_ref,  #Fortlaufende Nummer, der Lieferungen zwischen absender und Empfänger.
        leistungsbereich, #Leistungserbringer-Sammelgruppenschlüssel siehe 8.1.14.
        anwendungs_ref, #Logischer Dateiname
        erstellt_am: Time.now, # Erstellunszeitpunkt
        testindikator: PRODUCTION #0 wenn Testdatei, 1 wenn Erprobungsdatei, 2 wenn Echtdatei
      )
        @absender_datei = absender_datei
        @absender_bezeichnung = absender_bezeichnung
        @empfaenger_datei = empfaenger_datei
        @empfaenger_bezeichnung = empfaenger_bezeichnung
        @erstellt_am = erstellt_am
        @datenaustausch_ref = datenaustausch_ref.to_s.rjust(5, "0")[0..4]
        @leistungsbereich = leistungsbereich
        @anwendungs_ref = anwendungs_ref.to_s.rjust(5, "0")[0..4]
        @testindikator = testindikator

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
            RubyGkvBilling::Edifact::ENCODING,
            RubyGkvBilling::Edifact::VERSION
          ]
        )
        header_segment << @absender_datei
        header_segment << @absender_bezeichnung
        header_segment << @empfaenger_datei
        header_segment << @empfaenger_bezeichnung
        header_segment.add_splitted_element(
          [
            @erstellt_am.strftime("%Y%m%e"),
            @erstellt_am.strftime("%H%M")
          ]
        )
        header_segment << @datenaustausch_ref
        header_segment << @leistungsbereich
        header_segment << @anwendungs_ref
        header_segment << @testindikator

        header_segment
      end

      def footer_segment
        footer_segment = RubyGkvBilling::Edifact::Segment.new("UNZ")
        footer_segment << @message_count
        footer_segment << @datenaustausch_ref

        footer_segment
      end

      def to_edifact(join: RubyGkvBilling::Edifact::SEGMENT_JOIN)
        rows = [header_segment]
        rows += @messages
        rows << footer_segment

        rows.map(&:to_edifact).join(join)
      end
    end
  end
end
