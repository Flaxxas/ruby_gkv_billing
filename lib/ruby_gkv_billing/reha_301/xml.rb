module RubyGkvBilling
  module Reha301
    module Xml
      require 'nokogiri'

      require 'ruby_gkv_billing/reha_301/xml/base_document'

      ENCODING = 'ISO-8859-1'.freeze
      VERSION = "4.2.0".freeze
      HEADER_VERSION = '4.1.0'.freeze
      MAIN_VERSION = '4.2'.freeze

      def self.base_attributes
        {
          "xmlns:zsz": "http://www.vdek.com/xml-schema/ZSZ/4.1" ,
          "xmlns:kod": "http://www.vdek.com/xml-schema/KOD/4.1",
          "xmlns:atv": "http://www.vdek.com/xml-schema/ATV/4.2",
          "xmlns:zgr": "http://www.vdek.com/xml-schema/ZGR/4.1",
          "xmlns:abe": "http://www.vdek.com/xml-schema/ABE/4.1",
          "xmlns:bty": "http://www.vdek.com/xml-schema/BTY/4.1",
          "xmlns:anv": "http://www.vdek.com/xml-schema/ANV/4.1",
          "xmlns:feh": "http://www.vdek.com/xml-schema/FEH/4.1",
          "xmlns:apw": "http://www.vdek.com/xml-schema/APW/4.1",
          "xmlns:ebe": "http://www.vdek.com/xml-schema/EBE/4.1",
          "xmlns:aak": "http://www.vdek.com/xml-schema/AAK/4.2",
          "xmlns:ent": "http://www.vdek.com/xml-schema/ENTL/4.1",
          "xmlns:abk": "http://www.vdek.com/xml-schema/ABK/4.1",
          "xmlns:aap": "http://www.vdek.com/xml-schema/AAP/4.1",
          "xmlns:rec": "http://www.vdek.com/xml-schema/RECH/4.2",
          "xmlns:auf": "http://www.vdek.com/xml-schema/AUFN/4.1",
          "xmlns:reh": "http://www.vdek.com/xml-schema/REH/4.2",
          "xmlns:bew": "http://www.vdek.com/xml-schema/BEW/4.2",
          "xmlns:aav": "http://www.vdek.com/xml-schema/AAV/4.1",
          "xmlns:avk": "http://www.vdek.com/xml-schema/AVK/4.1",
          "xmlns:unt": "http://www.vdek.com/xml-schema/UNT/4.1",
          "xmlns:erg": "http://www.vdek.com/xml-schema/ERG/4.1",
          "xmlns:nra": "http://www.vdek.com/xml-schema/NRA/4.1"
        }
      end
    end
  end
end
