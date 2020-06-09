module RubyGkvBilling
  module Reha301
    module Xml
      class BaseDocument
        require 'nokogiri'

        def initialize(nachrichten_typ, with_header: true, papieranlage: false, freitext: nil)
          @nachrichten_typ = nachrichten_typ

          @with_header = with_header
          @papieranlage = papieranlage

          @freitext = freitext

          @documents = []
        end

        def to_xml
          if @with_header
            # ohne xml-tag
            xml_build.doc.root.to_xml
          else
            # fuer soap nur die Kind-Elemente
            xml_build.doc.root.children.to_xml
          end
        end

        def nachricht_xml(_xml)
        end

        def papieranlage
          if @papieranlage
            "J"
          else
            "N"
          end
        end

        private

        def xml_build
          return @xml_build if @xml_build

          @xml_build = Nokogiri::XML::Builder.new(encoding: RubyGkvBilling::Reha301::Xml::ENCODING) do |xml|

            xml.send("reh:Reha", RubyGkvBilling::Reha301::Xml.base_attributes) {
              xml["reh"].logische_Version RubyGkvBilling::Reha301::Xml::VERSION
              xml["reh"].Nachrichtentyp @nachrichten_typ

              nachricht_xml(xml)

              if @documents.any?
                xml.send("reh:Dokumente") {
                  @documents.each do |doc|
                    doc.to_xml(xml)
                  end
                }
              end

              if @freitext.to_s != ""
                xml["reh"].Freier_Text @freitext
              end
              xml["reh"].Papieranlage papieranlage
            }
          end
        end
      end
    end
  end
end
