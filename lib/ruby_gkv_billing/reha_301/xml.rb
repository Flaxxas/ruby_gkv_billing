module RubyGkvBilling
  module Reha301
    module Xml
      require 'nokogiri'

      require 'ruby_gkv_billing/reha_301/xml/base_document'

      ENCODING = 'ISO-8859-1'.freeze
      VERSION = "3.4.0".freeze

      def self.base_attributes
        {
          "xmlns:zsz": "http://www.vdek.com/xml-schema/ZSZ/3.4" ,
          "xmlns:kod": "http://www.vdek.com/xml-schema/KOD/3.4",
          "xmlns:atv": "http://www.vdek.com/xml-schema/ATV/3.4",
          "xmlns:zgr": "http://www.vdek.com/xml-schema/ZGR/3.4",
          "xmlns:abe": "http://www.vdek.com/xml-schema/ABE/3.4",
          "xmlns:bty": "http://www.vdek.com/xml-schema/BTY/3.4",
          "xmlns:anv": "http://www.vdek.com/xml-schema/ANV/3.4",
          "xmlns:feh": "http://www.vdek.com/xml-schema/FEH/3.4",
          "xmlns:apw": "http://www.vdek.com/xml-schema/APW/3.4",
          "xmlns:ebe": "http://www.vdek.com/xml-schema/EBE/3.4",
          "xmlns:aak": "http://www.vdek.com/xml-schema/AAK/3.4",
          "xmlns:ent": "http://www.vdek.com/xml-schema/ENTL/3.4",
          "xmlns:abk": "http://www.vdek.com/xml-schema/ABK/3.4",
          "xmlns:aap": "http://www.vdek.com/xml-schema/AAP/3.4",
          "xmlns:rec": "http://www.vdek.com/xml-schema/RECH/3.4",
          "xmlns:auf": "http://www.vdek.com/xml-schema/AUFN/3.4",
          "xmlns:reh": "http://www.vdek.com/xml-schema/REH/3.4",
          "xmlns:bew": "http://www.vdek.com/xml-schema/BEW/3.4",
          "xmlns:aav": "http://www.vdek.com/xml-schema/AAV/3.4",
          "xmlns:avk": "http://www.vdek.com/xml-schema/AVK/3.4",
          "xmlns:unt": "http://www.vdek.com/xml-schema/UNT/3.4",
          "xmlns:erg": "http://www.vdek.com/xml-schema/ERG/3.4"
        }
      end
    end
  end
end
