# Auftragsdatei
# https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_2_-_Auftragsdatei.pdf
module RubyGkvBilling
  class InstructionFile
    ENCODING = 'iso-8859-1'
    VERSION = '01'
    IDENTIFICATOR = '500000' # KK-Kommunikation
    INSTRUCTION_LENGTH = 348
    SEQUENZ_NR = '000' # keine Segmentierung
    FEHLER_NR = '000000' # kein Fehler
    FEHLER_MASSNAHME = '000000' # keine Massnahme erforderlich


    DATEIVERSION = '000000'
    KORREKTUR = '0'

    # https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_4_-_Verfahrenskennungen.pdf
    VERFAHREN_KENNUNG = 'SOL'

    DATEITYP = {
      "E" => "Echtdaten",
      "T" => "Testdaten"
    }

    ZEICHENSATZ = {
      "I1" => "ISO/IEC 8859-1: 1998(E) bzw. DIN 66303: 200-06",
      "I5" => "ISO 8859-15",
      "I7" => "ISO 7-Bit, Code gemäß DIN 66003 DRV(Deutsche Referenzversion)",
      "I8" => "DIN 66303 in der Fassung von 1986-11(DRV8)",
      "EB" => "EBCDIC(EBCDIC ist im Datenaustausch mit den Leistngserbringern gemäß §294 ff. SGB V nicht zulässig)",
      "P8" => "IBM-CODEPAGE 850(gilt nur nach biliteraler Vereinbarung)",
      "U8" => "UTF-8(gilt ausschließlich für den Datenaustausch mit der ZfA)",
      "BI" => "Binär)"
    }

    KOMPRIMIERUNG = {
      0 => "keine",
      2 => "gzip",
      3 => "ZIP",
      4 => "keine Belegung",
      7 => "bzip2"
    }

    VERSCHLUESSELUNG = {
      0 => "keine",
      3 => "PKCS#7-Format"
    }

    ABRECHNUNGSART = {
      "S" => "Selbstabrechner",
      "A" => "Abrechnungsstelle"
    }

    def initialize(
      transfer_nummer,
      absender_eigner, # Identifikation des Absenders
      absender_physikalisch, # Tatsaechlicher Absender
      empfaenger_nutzer, # Empfaenger, der die Daten nutzen soll
      empfaenger_physikalisch, # Tatsaechlicher Empfaenger
      abrechnungs_typ,
      dateityp,
      dateigroesse_nutzdaten,
      dateigroesse_uebertragung,
      zeichensatz,
      email_absender,
      datei_bezeichnung,
      komprimierung: "03",
      verschluesselungsart: "03",
      elektr_unterschrift: "03",
      datum_erstellt: Time.now,
      datum_gesendet: Time.now,
      datum_empf_start: Time.now,
      datum_empf_ende: Time.now,
      verfahren_kennung: VERFAHREN_KENNUNG,
      verfahren_kennung_spezifikation: VERFAHREN_KENNUNG,
      sequenz_nr: SEQUENZ_NR)

      @transfer_nummer = transfer_nummer
      @absender_eigner = absender_eigner
      @absender_physikalisch = absender_physikalisch
      @empfaenger_nutzer = empfaenger_nutzer
      @empfaenger_physikalisch = empfaenger_physikalisch
      @abrechnungs_typ = abrechnungs_typ
      @dateityp = dateityp
      @dateigroesse_nutzdaten = dateigroesse_nutzdaten
      @dateigroesse_uebertragung = dateigroesse_uebertragung
      @zeichensatz = zeichensatz
      @komprimierung = komprimierung
      @verschluesselungsart = verschluesselungsart
      @elektr_unterschrift = elektr_unterschrift
      @datum_erstellt = datum_erstellt
      @datum_gesendet = datum_gesendet
      @datum_empf_start = datum_empf_start
      @datum_empf_ende = datum_empf_ende
      @verfahren_kennung = verfahren_kennung
      @verfahren_kennung_spezifikation = verfahren_kennung_spezifikation
      @sequenz_nr = sequenz_nr
      @email_absender = email_absender
      @datei_bezeichnung = datei_bezeichnung #TODO Anzahl Gesamtpakete?
    end

    def content
      [
        basic_fields,
        tape_processing_fields,
        kks_fields,
        rz_fields
      ].join('')
    end

    def store(path)
      file_path = File.join(path, instruction_filename)
      file = File.open(file_path, "w:#{ENCODING}")
      file.puts(content)
      file.close
    end

    # Dateiname der Auftragsdatei
    def instruction_filename
      RubyGkvBilling::Edifact.physical_filename(@dateityp, @transfer_nummer)
    end

    # 2.1 Allgemeine KK-Felder
    def basic_fields

      datum_erstellt = @datum_erstellt.strftime("%Y%m%e%H%M%S") if @datum_erstellt
      datum_gesendet = @datum_gesendet.strftime("%Y%m%e%H%M%S") if @datum_gesendet
      datum_empf_start = @datum_empf_start.strftime("%Y%m%e%H%M%S") if @datum_empf_start
      datum_empf_ende = @datum_empf_ende.strftime("%Y%m%e%H%M%S") if @datum_empf_ende

      [
        numeric(IDENTIFICATOR, 6),
        numeric(VERSION, 2),
        numeric(INSTRUCTION_LENGTH, 8),
        numeric(@sequenz_nr, 3),
        alphanumeric(@verfahren_kennung, 5),
        numeric(@transfer_nummer, 3),
        alphanumeric(@verfahren_kennung_spezifikation, 5),
        alphanumeric(@absender_eigner, 15),
        alphanumeric(@absender_physikalisch, 15),
        alphanumeric(@empfaenger_nutzer, 15),
        alphanumeric(@empfaenger_physikalisch, 15),
        numeric(FEHLER_NR, 6),
        numeric(FEHLER_MASSNAHME, 6),
        alphanumeric(payload_filename, 11),
        numeric(datum_erstellt, 14),
        numeric(datum_gesendet, 14),
        numeric(datum_empf_start, 14),
        numeric(datum_empf_ende, 14),
        numeric(DATEIVERSION, 6),
        numeric(KORREKTUR, 1),
        numeric(@dateigroesse_nutzdaten, 12),
        numeric(@dateigroesse_uebertragung, 12),
        alphanumeric(@zeichensatz, 2),
        numeric(@komprimierung, 2),
        numeric(@verschluesselungsart, 2),
        numeric(@elektr_unterschrift, 2),
      ].join('')
    end

    # der Nutzdatendatei
    def payload_filename
      RubyGkvBilling::Edifact.logical_filename(@absender_eigner, @abrechnungs_typ, @datum_erstellt.month)
    end

    # 2.2 Bandverarbeitung
    def tape_processing_fields
      [
        alpha(nil, 3),
        numeric(nil, 5),
        numeric(nil, 8)
      ].join('')
    end

    # 2.3 KKS-Verfahren
    def kks_fields
      [
        alphanumeric('', 1),
        numeric('', 2),
        numeric('', 1),
        numeric('', 10),
        numeric('', 6),
        alphanumeric('', 28)
      ].join('')
    end

    # 2.4 RZ
    def rz_fields
      [
        alphanumeric(@email_absender, 44),
        alphanumeric(@datei_bezeichnung, 30)
      ].join('')
    end

    def numeric(value, digits)
      value.to_s[0..(digits - 1)].rjust(digits, '0')
    end

    def alpha(value, digits)
      value.to_s[0..(digits - 1)].ljust(digits, ' ')
    end

    def alphanumeric(value, digits)
      value.to_s[0..(digits - 1)].ljust(digits, ' ')
    end
  end
end
