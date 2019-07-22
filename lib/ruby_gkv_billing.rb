require 'ruby_gkv_billing/version'
require 'ruby_gkv_billing/edifact'
require 'ruby_gkv_billing/security'
require 'ruby_gkv_billing/instruction_file'

module RubyGkvBilling
  def self.root
    File.expand_path '..', __dir__
  end

  def self.file_path(path)
    File.join(root, path)
  end
end
