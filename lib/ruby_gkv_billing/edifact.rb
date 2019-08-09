# https://www.gkv-datenaustausch.de/media/dokumente/leistungserbringer_1/sonstige_leistungserbringer/technische_anlagen_aktuell_4/Anlage_1_TP5_V12_20190207.pdf
# https://www.gkv-datenaustausch.de/media/dokumente/leistungserbringer_1/sonstige_leistungserbringer/technische_anlagen_aktuell_4/Anlage_3_TP5_V12_20190213.pdf
require "ruby_gkv_billing/edifact/segment"
require "ruby_gkv_billing/edifact/payload"
require "ruby_gkv_billing/edifact/message"

module RubyGkvBilling
  module Edifact
    ELEMENT_DIVIDE_CHAR = '+'
    DATA_DIVIDE_CHAR = ':'
    DECIMAL_CHAR = ','
    REPLACE_CHAR = '?'
    SEGMENT_END_CHAR= "'"

    MESSAGE_VERSION = 12
    VERSION = 3
    ENCODING = 'UNOC'
    SEGMENT_JOIN = "\n"

    #8.1.14
    LEISTUNGSBEREICH = {
      "A" => "Leistungserbringer von Hilfsmitteln",
      "B" => "Leistungserbringer von Heilmitteln",
      "C" => "Leistungserbringer von häuslicher Krankenpflege",
      "D" => "Leistungserbringer von Haushaltshilfe",
      "E" => "Leistungserbringer von Krankentransportleistungen",
      "F" => "Hebammen",
      "G" => "nichtärztliche Dialysesachleistungen",
      "H" => "Leistungserbringer von Rehabilitationssport",
      "I" => "Leistungserbringer von Funktionstraining",
      "J" => "Weitere Sonstige Leistungserbringer, sofern nicht unter A - I und K - O aufgeführt",
      "K" => "Leistungserbringer von Präventions- und Gesundheitsförderungsmaßnahmen im Rahmen von ambulanten Vorsorgeleistungen",
      "L" => "Leistungserbringer für ergänzenden Rehamaß-nahmen",
      "M" => "Sozialpädiatrische Zentren/Frühförderstellen",
      "N" => "Soziotherapeutischer Leistungserbringer",
      "O" => "SAPV"
    }

    TESTINDIKATOR = {
      0 => "Testdatei",
      1 => "Erprobungsdatei",
      2 => "Echtdatei"
    }

    #8.1.7
    VERABEITUNGSKENNZEICHNUNG = {
      "01" => "Abrechnung ohne Besonderheiten",
      "02" => "Nachforderung",
      "03" => "Zuzahlungsforderung",
      "04" => "Korrekturrechnung"
    }

    #8.1.4
    RECHNUNGSART = {
      "0" => "Derzeit nicht belegt",
      "1" => "Abrechnung von Leistungserbringer und Zahlung an IK Leistungserbringer",
      "2" => "Abrechnung über Abrechnungsstelle (ohne Inkassovollmacht) und Zahlung an IK Leistungserbringer",
      "3" => "Abrechnung über Abrechnungsstelle (mit Inkassovollmacht) und Zahlung an IK Abrechnungsstelle"
    }

    #8.1.6
    STATUS = {
      "00" => "Gesamtsumme aller Status",
      "11" => "Mitglieder",
      "31" => "Angehörige",
      "51" => "Rentner",
      "99" => "nicht zuzuordnende Status"
    }

    # 4.2
    #type: "S" => Selbstabrechner, "A" => Abrechnungsstelle
    def self.logical_filename(ik_number, type, month, classification: "SL")
      [
        classification,
        ik_number[2..3],
        ik_number[4..7],
        type[0],
        month.to_s.rjust(2, "0")[0..1]
      ].join("")
    end

    # 4.3
    #data_type: "E" => Echtdaten, "T" => Testdaten
    def self.physical_filename(data_type, transfer_number, leistung_erbringer_gruppe: "SOL", version: "0")
      [
        data_type.to_s[0],
        leistung_erbringer_gruppe.to_s[0..2],
        version.to_s[0],
        transfer_number.to_s.rjust(3, "0")[0..2]
      ].join("")
    end
  end
end
