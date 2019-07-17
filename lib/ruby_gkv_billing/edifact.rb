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
  end
end
