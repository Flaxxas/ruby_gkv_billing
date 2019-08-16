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

    #8.1.2
    UNFALL = {
      1 => "Arbeitsunfall / Wegeunfall / Berufskrankheit",
      2 => "sonstige Unfallfolgen",
      3 => "Sonstiges (BVFG, BEG, HHG, OEG, IfSG, SVG)"
    }

    #8.1.2.1
    BVG = {
      6 => "BVG"
    }

    #8.1.3
    ZUZAHLUNG = {
      0 => "keine gesetzliche Zuzahlung",
      1 => "Zuzahlungsbefreit",
      2 => "keine Zuzahlung trotz schriftlicher Zahlungsaufforderung",
      3 => "Zuzahlungspflichtig",
      4 => "Übergang zuzahlungspflichtig zu zuzahlungsfrei",
      5 => "Übergang zuzahlungspflichtig zu zuzahlungsfrei"
    }

    #8.1.4
    RECHNUNGSART = {
      0 => "Derzeit nicht belegt",
      1 => "Abrechnung von Leistungserbringer und Zahlung an IK Leistungserbringer",
      2 => "Abrechnung über Abrechnungsstelle (ohne Inkassovollmacht) und Zahlung an IK Leistungserbringer",
      3 => "Abrechnung über Abrechnungsstelle (mit Inkassovollmacht) und Zahlung an IK Abrechnungsstelle"
    }

    #8.1.6
    STATUS = {
      "00" => "Gesamtsumme aller Status",
      "11" => "Mitglieder",
      "31" => "Angehörige",
      "51" => "Rentner",
      "99" => "nicht zuzuordnende Status"
    }

    #8.1.11
    VERORDUNG_BESONDERS = {
      1 => "Verordnung von einem Zahnarzt/Kieferorthopäden",
      2 => "Verordnung im Zusammenhang mit der Schwangerschaft oder der Entbindung",
      3 => "Verordnung im Rahmen des Modellvorhabens nach
§ 64d SGB V (Blanko-Verordnung)",
      4 => "Verordnung im Rahmen des Entlassmanagements",
      7 => "Verordnung im Rahmen der Terminservicestellen"
    }

    #8.1.18
    BELEG_INFORMATION = {
      "0" => "keine Belegübermittlung zum Fall",
      "1" => "Belege zum Fall üer Post übermittelt",
      "2" => "Belege zum Fall elektronisch (z.B. Image) übermittelt"
    }

    #8.1.17
    #TODO ergaenzen
    GENEHMIGUNGSART = {
      "B1" => "Heilmittel - Genehmigung gemäß §8 Abs. 4 bzw. §7 Abs. 4",
      "B2" => "Heilmittel - Genehmigung gemäß §8a Abs. 3 bzw. §8 Abs. 1",
      "J1" => "Sonstige - J Sonstige Leistungserbringer - Genehmigung im Einzelfall",
      "L1" => "Sonstige - L Ambulantes Rehazentrum - Genehmigung im Einzelfall",
      "M1" => "Sonstige - M Sozialpädiatrische Zentren/Frühförderstellen - Genehmigung im Einzelfall",
      "N1" => "Sonstige - N Soziotherapeutische Leistungserbringer - Genehmigung im Einzelfall"
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
