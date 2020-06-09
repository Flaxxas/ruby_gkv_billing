require 'ruby_gkv_billing/version'
require 'ruby_gkv_billing/edifact'
require 'ruby_gkv_billing/security'
require 'ruby_gkv_billing/instruction_file'
require 'ruby_gkv_billing/provider_file'
require 'ruby_gkv_billing/provider'
require 'ruby_gkv_billing/reha_301'

module RubyGkvBilling
  def self.root
    File.expand_path '..', __dir__
  end

  def self.file_path(path)
    File.join(root, path)
  end

  REHA_301_SCHEMA = file_path('docs/Reha301/schema/EREH0-REH-3.4.0.xsd').freeze
end
