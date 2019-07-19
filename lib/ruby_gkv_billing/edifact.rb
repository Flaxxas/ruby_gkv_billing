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

    #type: "S" => Selbstabrechner, "A" => Abrechnungsstelle
    def self.logical_filename(region_key, serial_number, type, month, classification: "SL")
      [
        classification,
        region_key[0..1],
        serial_number[0..3],
        type[0],
        month.to_s.rjust(2, "0")[0..1]
      ].join("")
    end

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
