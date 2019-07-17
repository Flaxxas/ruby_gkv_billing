require "ruby_gkv_billing/edifact/segment"
require "ruby_gkv_billing/edifact/message"
require "ruby_gkv_billing/edifact/payload"

module RubyGkvBilling
  module Edifact
    ELEMENT_DIVIDE_CHAR = '+'
    DATA_DIVIDE_CHAR = ':'
    DECIMAL_CHAR = ','
    REPLACE_CHAR = '?'
    SEGMENT_END_CHAR= "'"

    MESSAGE_VERSION = 12
    VERSION = 3
  end
end
