# https://www.gkv-datenaustausch.de/media/dokumente/leistungserbringer_1/sonstige_leistungserbringer/technische_anlagen_aktuell_4/Anhang_03_Anlage_1_TP5_20200408.pdf
# require 'edifact_tools'

module RubyGkvBilling
  class Provider

    # 8.1
    ART_ANSCHRIFT = {
      "1" => "1 - Hausanschrift",
      "2" => "2 - Postfachanschrift",
      "3" => "3 - Großkundenanschrift"
    }

    # 8.2
    ART_DATENLIEFERUNG = {
      "07" => "07 - Rechnungs- und Abrechnungsdaten SLGA und SLLA digitalisiert",
      "21" => "21 - Rechnung (Papier)",
      "24" => "24 - maschinenlesbarer Beleg",
      "26" => "26 - Verordnung (Papier)",
      "27" => "27 - Kostenvoranschlag (Papier)",
      "28" => "28 - Gruppenschlüssel (Einzelschlüssel 21, 26, 27) papiergebundene Unterlagen einer digitalen Abrechnung (Verordnung, ggf. Kostenvoranschlag, ggf. Rechnung)",
      "29" => "29 - Gruppenschlüssel (Einzelschlüssel 24, 26, 27) maschinenlesbarer Beleg einschließlich der dazugehörigen Abrechnungsunterlagen"
    }

    # 8.3
    ART_VERKNUEPFUNG_INSTITUTIONSKENNZEICHEN = {
      "01" => "01 - Verweis vom IK der Versichertenkarte zum Kostenträger",
      "02" => "02 - Verweis auf eine Datenannahmestelle (ohne Entschlüsselungsbefugnis) Schlüssel ist nur gültig in Verbindung mit dem Schlüssel 07 'Art der Datenlieferung'",
      "03" => "03 - Verweis auf eine Datenannahmestelle (mit Entschlüsselungsbefugnis) Schlüssel ist nur gültig in Verbindung mit dem Schlüssel 07 'Art der Datenlieferung'",
      "09" => "09 - Verweis auf eine Papierannahmestelle"
    }

    # 8.4
    BUNDESLAND = {
      "01" => "01 - Schleswig-Holstein",
      "02" => "02 - Hamburg",
      "03" => "03 - Niedersachsen",
      "04" => "04 - Bremen",
      "05" => "05 - Nordrhein-Westfalen",
      "06" => "06 - Hessen",
      "07" => "07 - Rheinland-Pfalz",
      "08" => "08 - Baden-Württemberg",
      "09" => "09 - Bayern",
      "10" => "10 - Saarland",
      "11" => "11 - Berlin",
      "12" => "12 - Brandenburg",
      "13" => "13 - Mecklenburg-Vorpommern",
      "14" => "14 - Sachsen",
      "15" => "15 - Sachsen-Anhalt",
      "16" => "16 - Thüringen",
      "99" => "99 - Alle Bundesländer (bei Datenlieferungen)"
    }

    # 8.5
    TRANSMISSION_PROTOCOLS = {
      "016" => "FTAM",
      "023" => "FTP",
      "070" => "E-Mail/Internet"
    }

    # 8.7
    KV_BEZIRK = {
      "01" => "01 - Schleswig-Holstein",
      "02" => "02 - Hamburg",
      "03" => "03 - Bremen",
      "06" => "06 - Bezirksstelle Aurich",
      "07" => "07 - Bezirksstelle Braunschweig",
      "08" => "08 - Bezirksstelle Göttingen",
      "09" => "09 - Bezirksstelle Hannover",
      "10" => "10 - Bezirksstelle Hildesheim",
      "11" => "11 - Bezirksstelle Lüneburg",
      "12" => "12 - Bezirksstelle Oldenburg",
      "13" => "13 - Bezirksstelle Osnabrück",
      "14" => "14 - Bezirksstelle Stade",
      "15" => "15 - Bezirksstelle Verden",
      "16" => "16 - Bezirksstelle Wilhelmshaven",
      "17" => "17 - Niedersachsen",
      "18" => "18 - Verwaltungsstelle Dortmund",
      "19" => "19 - Verwaltungsstelle Münster",
      "20" => "20 - Westfalen-Lippe",
      "21" => "21 - Bezirksstelle Aachen",
      "24" => "24 - Bezirksstelle Düesseldorf",
      "25" => "25 - Bezirksstelle Duisburg",
      "27" => "27 - Bezirksstelle Köln",
      "28" => "28 - Bezirksstelle Linker Niederrhein",
      "31" => "31 - Bezirksstelle Ruhr",
      "37" => "37 - Bezirksstelle Bergisch-Land",
      "38" => "38 - Nordrhein",
      "39" => "39 - Bezirksstelle Darmstadt",
      "40" => "40 - Bezirksstelle Frankfurt",
      "41" => "41 - Bezirksstelle Giessen",
      "42" => "42 - Bezirksstelle Kassel",
      "43" => "43 - Bezirksstelle Limburg",
      "44" => "44 - Bezirksstelle Marburg",
      "45" => "45 - Bezirksstelle Wiesbaden",
      "46" => "46 - Hessen",
      "47" => "47 - Koblenz",
      "48" => "48 - Rheinhessen",
      "49" => "49 - Pfalz",
      "50" => "50 - Trier",
      "52" => "52 - Abrechnungsstelle Karlsruhe",
      "53" => "53 - Abrechnungsstelle Mannheim",
      "54" => "54 - Abrechnungsstelle Pfortzheim",
      "55" => "55 - Nordbaden",
      "56" => "56 - Abrechnungsstelle Baden-Baden",
      "57" => "57 - Abrechnungsstelle Freiburg",
      "58" => "58 - Abrechnungsstelle Konstanz",
      "59" => "59 - Abrechnungsstelle Offenburg",
      "60" => "60 - Südbaden",
      "61" => "61 - Nordwürttemberg",
      "62" => "62 - Südwürttemberg",
      "63" => "63 - Bezirksstelle München Stadt u. Land",
      "64" => "64 - Bezirksstelle Oberbayern",
      "65" => "65 - Bezirksstelle Oberfranken",
      "66" => "66 - Bezirksstelle Mittelfranken",
      "67" => "67 - Bezirksstelle Unterfranken",
      "68" => "68 - Bezirksstelle Oberpfalz",
      "69" => "69 - Bezirksstelle Niederbayern",
      "70" => "70 - Bezirksstelle Schwaben",
      "71" => "71 - Bayerns",
      "72" => "72 - Berlin",
      "73" => "73 - Saarland",
      "78" => "78 - Mecklenburg-Vorpommern",
      "79" => "79 - Abrechnungsstelle Potsdam",
      "80" => "80 - Abrechnungsstelle Cottbus",
      "81" => "81 - Abrechnungsstelle Frankfurt/oder",
      "83" => "83 - Brandenburg",
      "85" => "85 - Abrechnungsstelle Magdeburg",
      "86" => "86 - Abrechnungsstelle Halle",
      "87" => "87 - Abrechnungsstelle Dessau",
      "88" => "88 - Sachsen-Anhalt",
      "89" => "89 - Abrechnungsstelle Erfurt",
      "90" => "90 - Abrechnungsstelle Gera",
      "91" => "91 - Abrechnungsstelle Suhl",
      "93" => "93 - Thüringen",
      "98" => "98 - Sachsen",
      "94" => "94 - Bezirksstelle Chemnitz",
      "95" => "95 - Bezirksstelle Dresden",
      "96" => "96 - Bezirksstelle Leipzig"
    }

    # 8.8
    LEISTUNGSERBRINGERGRUPPE = {
      "5" => "Sonstige Leistungserbringer"
    }

    # 8.9
    UEBERMITTLUNGSMEDIUM = {
      "1" => "1 - DFÜ",
      "2" => "2 - Magnetband",
      "3" => "3 - Magnetbandkassette",
      "4" => "4 - Diskette",
      "5" => "5 - Maschinenlesbarer Beleg",
      "6" => "6 - Nicht maschinenlesbarer Beleg",
      "7" => "7 - CD-ROM",
      "9" => "9 - Alle Datenträger (Schlüssel 2 bis 4 und 7)"
    }

    # 8.10
    UEBERMITTLUNGSMEDIUM_PARAMETER = {
      "00" => "00 - kein Parameter (DFÜ-Parameter sind im Segment DFU hinterlegt)",
      "02" => "02 - Magnetband 6250 bpi",
      "03" => "03 - Magnetbandkassette 3480",
      "04" => "04 - Magnetbandkassette 3490 - 18 Spur",
      "05" => "05 - Magnetbandkassette 3490 - 36 Spur",
      "08" => "08 - Diskette 3,5\" - 720 KB - DOS-Format",
      "09" => "09 - Diskette 3,5\" - 1,44 MB - DOS-Format",
      "10" => "10 - Diskette 3,5\" - 2,88 MB - DOS-Format",
      "14" => "14 - CD-ROM, 12 cm, 650 MB"
    }

    # 8.11
    UEBERMITTLUNGSZEICHENSATZ = {
      "I7" => "ASCII 7-Bit",
      "I8" => "ASCII 8-Bit"
    }

    # 8.13
    VERABREITUNGSKENNZEICHEN = {
      "01" => "01 - Neuanmeldung",
      "02" => "02 - Änderung",
      "03" => "03 - Stornierung",
      "04" => "04 - Unverändert"
    }

    #  8.12
    TRANSMISSION_DAYS = {
      "1" => "Übertragung an allen Tagen",
      "2" => "Übertragung nur an Werktage (Montag bis Samstag außer Feiertag)",
      "3" => "Übertragung nur an Arbeitstagen (Montag bis Freitag außer Feiertag)"
    }

    attr_accessor :provider_message, :data_recipient_message

    def initialize(provider_category, client_idk, billing_code)
      load_provider_file(provider_category, client_idk, billing_code)
    end

    def load_provider_file(provider_category, client_idk, billing_code)
      provider_file = RubyGkvBilling::ProviderFile.new(provider_category)
      contact_messages = provider_file.contact_messages(client_idk, billing_code)
      @provider_message = contact_messages[:provider_message]
      @data_recipient_message = contact_messages[:data_recipient_message]
    end

    def provider_ik
      ik("provider")
    end

    def provider_short_name
      short_name("provider")
    end

    def provider_full_name
      full_name("provider")
    end

    def provider_addresses
      addresses("provider")
    end

    def provider_contact_persons
      contact_persons("provider")
    end

    def data_recipient_ik
      ik("data_recipient")
    end

    def data_recipient_short_name
      short_name("data_recipient")
    end

    def data_recipient_full_name
      full_name("data_recipient")
    end

    def data_recipient_addresses
      addresses("data_recipient")
    end

    def data_recipient_contact_persons
      contact_persons("data_recipient")
    end

    def data_recipient_transmissions
      transmissions = []
      transmission_segments = @data_recipient_message.data_entry("Segment_DFÜ") if @data_recipient_message
      if transmission_segments
        transmission_segments.each do |s|
          transmission = {}

          protocol = s["Übertragungsprotokoll"]
          if TRANSMISSION_PROTOCOLS[protocol]
            protocol = TRANSMISSION_PROTOCOLS[protocol]
          end
          transmission[:protocol] = protocol

          transmission[:user_id] = s["Benutzerkennung"]

          t_from = s["Übertragung_von"]
          t_from = t_from.insert(2, ":") if t_from && t_from.length == 4
          transmission[:transmission_from] = t_from

          t_to = s["Übertragung_bis"]
          t_to = t_to.insert(2, ":") if t_to && t_to.length == 4
          transmission[:transmission_to] = t_to

          days = s["Übertragungstage"]
          if TRANSMISSION_DAYS[days]
            days = TRANSMISSION_DAYS[days]
          end
          transmission[:transmission_days] = days
          transmission[:communication_channel] = s["Kommunikationskanal"]
          transmissions.push(transmission)
        end
      end
      transmissions
    end

    private

    def ik(message_type)
      message = self.send("#{message_type}_message")
      message.data_entry("Segment_Identifikation", "Institutionskennzeichen") if message
    end

    def short_name(message_type)
      message = self.send("#{message_type}_message")
      message.data_entry("Segment_Identifikation", "Kurzbezeichnung") if message
    end

    def full_name(message_type)
      full_name = ""
      ["Name-1", "Name-2", "Name-3", "Name-4"].each_with_index do |n, i|
        message = self.send("#{message_type}_message")
        name = message.data_entry("Segment_Name", n) if message
        if name
          full_name.concat(" ") if i != 0
          full_name.concat(name)
        end
      end

      if !full_name.empty?
        full_name
      else
        nil
      end
    end

    def addresses(message_type)
      addresses = []
      message = self.send("#{message_type}_message")
      address_segments = message.data_entry("Segment_Anschrift") if message
      if address_segments
        address_segments.each do |s|
          address = {}
          address[:code] = s["Postleitzahl"]
          address[:city] = s["Ort"]
          address[:street] = s["Straße,Hausnr/Postfach"]
          addresses.push(address)
        end
      end
      addresses
    end

    def contact_persons(message_type)
      contact_persons = []
      message = self.send("#{message_type}_message")
      contact_person_segments = message.data_entry("Segment_Ansprechpartner") if message
      if contact_person_segments
        contact_person_segments.each do |p|
          contact_person = {}
          contact_person[:phone] = p["Telefon"]
          contact_person[:fax] = p["Fax"]
          contact_person[:name] = p["Name"]
          contact_person[:working_area] = p["Arbeitsgebiet_des_Ansprechpartners"]
          contact_persons.push(contact_person)
        end
      end
      contact_persons
    end
  end
end
