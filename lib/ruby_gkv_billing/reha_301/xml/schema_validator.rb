module RubyGkvBilling
  module Reha301
    module Xml
      class SchemaValidator
        require 'nokogiri'

        def initialize(xml_content, version: RubyGkvBilling::Reha301::Xml::VERSION)
          @version = version
          @xml_content = xml_content
          @xml = Nokogiri::XML(xml_content)

          @errors = schema.validate(@xml)
        end

        def to_xml
          @xml_content
        end

        def valid?
          @errors.empty?
        end

        def errros
          @errors
        end

        def schema_file
          @schema_file ||= RubyGkvBilling.file_path("docs/Reha301/schema/EREH0-REH-#{@version}.xsd")
        end

        def schema
          @schema ||= Nokogiri::XML::Schema(File.open(schema_file))
        end
      end
    end
  end
end
