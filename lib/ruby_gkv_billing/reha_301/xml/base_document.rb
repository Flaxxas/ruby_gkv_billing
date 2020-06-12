module RubyGkvBilling
  module Reha301
    module Xml
      class BaseDocument
        require 'nokogiri'

        TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

        def initialize(nachrichten_typ, with_header: true, papieranlage: false, freitext: nil, drv: false)
          @nachrichten_typ = nachrichten_typ

          @with_header = with_header
          @papieranlage = papieranlage

          @freitext = freitext

          @drv = drv

          @documents = []
        end

        def add_documen(document)
          @documents << document
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
            'J'
          else
            'N'
          end
        end

        def rv_type
          if @drv
            'RV'
          else
            'KV'
          end
        end

        def kopfdaten_head(
          xml,
          dateinummer,
          ik_absender,
          ik_empfaenger,
          ik_kostentraeger,
          ik_beauftragte_stelle,
          ik_einrichtung,
          fachabteilung,
          version: RubyGkvBilling::Reha301::Xml::VERSION,
          erstellungsdatum: Time.now
        )
          xml["kod"].Erstellungsdatum_Uhrzeit erstellungsdatum.strftime(TIME_FORMAT)
          xml["kod"].Version version
          xml["kod"].Dateinummer dateinummer.to_i
          xml.send("kod:Identifikationsdaten") {
            xml["kod"].IK_Absender ik_absender
            xml["kod"].IK_Empfaenger ik_empfaenger
            xml["kod"].IK_Kostentraeger ik_kostentraeger
            if ik_beauftragte_stelle.to_s != ''
              xml["kod"].IK_beauftragte_Stelle ik_beauftragte_stelle
            end
            xml["kod"].IK_Einrichtung ik_einrichtung
            xml["kod"].Fachabteilung fachabteilung
          }
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
