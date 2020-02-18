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

    MESSAGE_VERSION = 13
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

    #8.1.5.1
    ABRECHNUNGSCODE = {
      "11" => "Apotheke (mit gesonderter Zulassung nach § 126 SGB V)",
      "12" => "Augenoptiker",
      "13" => "Augenarzt",
      "14" => "Hörgeräteakustiker",
      "15" => "Orthopädiemechaniker, Bandagist, Sanitätshaus",
      "16" => "Orthopädieschuhmacher",
      "17" => "Orthopäde",
      "18" => "Sanitätshaus (Bei neuen Verträgen bzw. Vertragsanpassungen ist eine Umschlüsselung mit dem Abrechnungscode 15 vorzunehmen. Der Abrechnungscode 18 wird für Sanitätshäuser zum 31.12.2005 aufgehoben.)",
      "19" => "sonstiger Hilfsmittellieferant",
      "21" => "Masseur/Medizinischer Badebetrieb",
      "22" => "Krankengymnast/Physiotherapeut",
      "23" => "Logopäde, Atem-, Sprech- und Stimmlehrer, staatl. anerkannter Sprachtherapeut,",
      "24" => "Sprachheilpädagoge, Dipl. Pädagoge",
      "25" => "Sonstiger Sprachtherapeut",
      "26" => "Ergotherapeut",
      "27" => "Krankenhaus",
      "28" => "Kurbetrieb",
      "29" => "Sonstige therapeutische Heilperson",
      "31" => "freigemeinnützige Anbieter (Sozialstation)",
      "32" => "privatgewerbliche Anbieter",
      "33" => "öffentliche Anbieter",
      "34" => "Sonstige Pflegedienste",
      "41" => "Öffentlicher Anbieter von qualifizierten Krankentransport-Leistungen (z.B. Feuerwehr)",
      "42" => "Deutsches Rotes Kreuz (DRK)",
      "43" => "Arbeiter-Samariter-Bund (ASB)",
      "44" => "Johanniter-Unfall-Hilfe (JUH)",
      "45" => "Malteser-Hilfsdienst (MHD)",
      "46" => "Sonstiger Leistungserbringer von nichtqualifizierten Krankentransportleistungen (z.b. Taxi/Mietwagen)",
      "47" => "Leistungserbringer von Flugrettungs- und Transportleistungen",
      "48" => "Sonstiger nichtöffentlicher Anbieter von qualifizierten Krankentransport- bzw. Rettungsdienstleistungen",
      "49" => "Sonstiger Anbieter von Krankentransportleistungen (z.B. Bergwacht, Wasserwacht etc.)",
      "50" => "Hebamme/Entbindungspfleger",
      "55" => "Sonstiger Leistungserbringer von nichtärztlichen Dialysesachleistungen",
      "56" => "Kuratorium für Heimdialyse (KfH)",
      "57" => "Patienten-Heimversorgung (PHV)",
      "60" => "Betriebshilfe",
      "61" => "Leistungserbringer von Rehabilitationssport",
      "62" => "Leistungserbringer von Funktionstraining",
      "63" => "Leistungserbringer für ergänzende Rehabilitationsmaßnahmen",
     #"64" => "- nicht besetzt -",
      "65" => "Sonstiger Leistungserbringer",
      "66" => "Leistungserbringer von Präventions- und Gesundheitsförderungsmaßnahmen im Rahmen von ambulanten Vorsorgeleistungen",
      "67" => "Ambulantes Rehazentrum / Mobile Rehabilitationseinrichtung",
      "68" => "Sozialpädiatrische Zentren/Frühförderstellen",
      "69" => "Soziotherapeutischer Leistungserbringer",
      "75" => "Spezialisierte ambulante Palliativversorgung (SAPV)",
      "76" => "Leistungserbringer nach § 132g SGB V",
      "71" => "Podologen",
      "72" => "Med. Fußpfleger (gemäß § 10 Abs. 4 bis 6 PodG)",
      "73" => "Leistungserbringer von Ernährungstherapie für seltene angeborene Stoffwechselerkrankungen",
      "74" => "Leistungserbringer von Ernährungstherapie für Mukoviszidose"
    }

    #8.1.5.2
    TARIFKENNZEICHEN = {
      "00" => "Bundeseinheitlicher Tarif(gültig für Ost und West)",
      "01" => "Baden-Württemberg",
      "02" => "Bayern",
      "03" => "Berlin Ost",
      "04" => "Bremen",
      "05" => "Hamburg",
      "06" => "Hessen",
      "07" => "Niedersachsen",
      "08" => "Nordrhein-Westfalen",
      "09" => "Rheinland-Pfalz",
      "10" => "Saarland",
      "11" => "Schleswig-Holstein",
      "12" => "Brandenburg",
      "13" => "Sachsen",
      "14" => "Sachsen-Anhalt",
      "15" => "Mecklenburg-Vorpommern",
      "16" => "Thüringen",
      "17" => "Stuttgart und Karlsruhe",
      "18" => "Freiburg und Tübingen",
      "19" => "Berlin West",
      "20" => "Nordrhein",
      "21" => "Westfalen-Lippe",
      "22" => "Lippe",
      "23" => "Berlin (gesamt)",
      "24" => "Bundeseinheitlicher Tarif (West)",
      "25" => "Bundeseinheitlicher Tarif (Ost)",
     #"26"-"49" => "noch zu vergeben",
      "50" => "Bundesvertrag",
      "51" => "Baden-Württemberg",
      "52" => "Bayern",
      "53" => "Berlin Ost",
      "54" => "Bremen",
      "55" => "Hamburg",
      "56" => "Hessen",
      "57" => "Niedersachsen",
      "58" => "Nordrhein-Westfalen",
      "59" => "Rheinland-Pfalz",
      "60" => "Saarland",
      "61" => "Schleswig-Holstein",
      "62" => "Brandenburg",
      "63" => "Sachsen",
      "64" => "Sachsen-Anhalt",
      "65" => "Mecklenburg-Vorpommern",
      "66" => "Thüringen",
      "67" => "Stuttgart und Karlsruhe",
      "68" => "Freiburg und Tübingen",
      "69" => "Berlin West",
      "70" => "Nordrhein",
      "71" => "Westfalen-Lippe",
      "72" => "Lippe",
      "73" => "Berlin (gesamt)",
      "74" => "Bundeseinheitlicher Tarif (West)",
      "75" => "Bundeseinheitlicher Tarif (Ost)",
     #"76"-"89" => "noch zu vergeben",
      "90" => "sonstiger länderübergreifender Tarif",
      "91" => "Vetrag auf Kassenebene",
      "92" => "Vetrag auf Kassenebene",
      "93" => "Vetrag auf Kassenebene",
      "94" => "Vetrag auf Kassenebene",
      "95" => "Vetrag auf Kassenebene",
      "96" => "Vetrag auf Kassenebene",
      "97" => "Vetrag auf Kassenebene",
      "98" => "Vetrag auf Kassenebene",
      "99" => "Vetrag auf Kassenebene"
    }

    #8.1.6 + https://de.wikipedia.org/wiki/Versichertenstatus
    STATUS = {
      "00" => "Gesamtsumme aller Status",
      "11" => "Mitglieder",
      "31" => "Angehörige",
      "51" => "Rentner",
      "99" => "nicht zuzuordnende Status"
    }

    #8.1.8
    MWST_KENNZEICHEN = {
      1 => "voller Mehrwertsteuersatz, dem Einzelbetrag zuzurechnen",
      2 => "ermäßigter Mehrwertsteuersatz, dem Einzelbetrag zuzurechnen"
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
      "1" => "Belege zum Fall über Post übermittelt",
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

    # 8.1.12
    VERORDNUNGSART = {
      "01" => "Erstverordnung (Regelfall)",
      "02" => "Folgeverordnung (Regelfall)",
      "03" => "nicht besetzt",
      "04" => "nicht besetzt",
      "10" => "Verordnung außerhalb des Regelfalles (Folgeverordnung, auch längerfristige Verordnung)",
      "11" => "nicht besetzt"
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
