# Auftragsdatei
# https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_2_-_Auftragsdatei.pdf
module RubyGkvBilling
  class InstructionFile
    ENCODING = 'iso-8859-1'
    VERSION = '01'
    IDENTIFICATOR = '500000' # KK-Kommunikation
    INSTRUCTION_LENGTH = 348
    SEQUENZ_NR = '000' # keine Segmentierung

    DATEIVERSION = '000000'
    KORREKTUR = '0'

    # https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_4_-_Verfahrenskennungen.pdf
    VERFAHREN_KENNUNG = 'SOL'

    def initialize
      # code
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
      # code
    end

    # 2.1 Allgemeine KK-Felder
    def basic_fields
      [
      ].join('')
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
        # E-MAIL-ADRESSE
        # DATEI_BEZEICHNUNG
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
