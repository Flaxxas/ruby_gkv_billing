module RubyGkvBilling
  module Reha301
    module Xml
      require 'nokogiri'

      require 'ruby_gkv_billing/reha_301/xml/base_document'

      ENCODING = 'ISO-8859-1'.freeze
      VERSION = "4.2.0".freeze
      HEADER_VERSION = '4.1.0'.freeze
      MAIN_VERSION = '4.2'.freeze

      ZSZ = "4.1"
      KOD = "4.1"
      ATV = "4.2"
      ZGR = "4.1"
      ABE = "4.1"
      BTY = "4.1"
      ANV = "4.1"
      FEH = "4.1"
      APW = "4.1"
      EBE = "4.1"
      AAK = "4.2"
      ENTL = "4.1"
      ABK = "4.1"
      AAP = "4.1"
      RECH = "4.2"
      AUFN = "4.1"
      REH = "4.2"
      BEW = "4.2"
      AAV = "4.1"
      AVK = "4.1"
      UNT = "4.1"
      ERG = "4.1"
      NRA = "4.1"

      def self.base_attributes
        {
          "xmlns:zsz": "http://www.vdek.com/xml-schema/ZSZ/#{ZSZ}",
          "xmlns:kod": "http://www.vdek.com/xml-schema/KOD/#{KOD}",
          "xmlns:atv": "http://www.vdek.com/xml-schema/ATV/#{ATV}",
          "xmlns:zgr": "http://www.vdek.com/xml-schema/ZGR/#{ZGR}",
          "xmlns:abe": "http://www.vdek.com/xml-schema/ABE/#{ABE}",
          "xmlns:bty": "http://www.vdek.com/xml-schema/BTY/#{BTY}",
          "xmlns:anv": "http://www.vdek.com/xml-schema/ANV/#{ANV}",
          "xmlns:feh": "http://www.vdek.com/xml-schema/FEH/#{FEH}",
          "xmlns:apw": "http://www.vdek.com/xml-schema/APW/#{APW}",
          "xmlns:ebe": "http://www.vdek.com/xml-schema/EBE/#{EBE}",
          "xmlns:aak": "http://www.vdek.com/xml-schema/AAK/#{AAK}",
          "xmlns:ent": "http://www.vdek.com/xml-schema/ENTL/#{ENTL}",
          "xmlns:abk": "http://www.vdek.com/xml-schema/ABK/#{ABK}",
          "xmlns:aap": "http://www.vdek.com/xml-schema/AAP/#{AAP}",
          "xmlns:rec": "http://www.vdek.com/xml-schema/RECH/#{RECH}",
          "xmlns:auf": "http://www.vdek.com/xml-schema/AUFN/#{AUFN}",
          "xmlns:reh": "http://www.vdek.com/xml-schema/REH/#{REH}",
          "xmlns:bew": "http://www.vdek.com/xml-schema/BEW/#{BEW}",
          "xmlns:aav": "http://www.vdek.com/xml-schema/AAV/#{AAV}",
          "xmlns:avk": "http://www.vdek.com/xml-schema/AVK/#{AVK}",
          "xmlns:unt": "http://www.vdek.com/xml-schema/UNT/#{UNT}",
          "xmlns:erg": "http://www.vdek.com/xml-schema/ERG/#{ERG}",
          "xmlns:nra": "http://www.vdek.com/xml-schema/NRA/#{NRA}"
        }
      end
    end
  end
end
