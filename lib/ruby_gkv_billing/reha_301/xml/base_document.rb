module RubyGkvBilling
  module Reha301
    module Xml
      class BaseDocument
        require 'nokogiri'

        TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

        def initialize(nachrichten_typ, with_header: true, papieranlage: false, freitext: nil, drv: false, without_empty: true)
          @nachrichten_typ = nachrichten_typ

          @with_header = with_header
          @without_empty = without_empty
          @papieranlage = papieranlage

          @freitext = freitext

          @drv = drv

          @documents = []
        end

        def add_documen(document)
          @documents << document
        end

        def to_xml
          if @without_empty
            # entferne leere Knoten
            xml_build.doc.traverse do |node|
              node.remove if node.element? && node.text == ""
            end
          end

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
          bool_value(@papieranlage)
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

        def kv_id(
          xml,
          vertragskennzeichen,
          kv_nummer,
          lebendspende,
          ik_kv_karte,
          fallnummer
        )

          xml.send("kod:Fall_ID_KV") {
            if vertragskennzeichen.to_s != ''
              xml["kod"].Vertragskennzeichen vertragskennzeichen
            end
            xml["kod"].Krankenversichertennummer kv_nummer
            xml["kod"].Lebendspende bool_value(lebendspende)
            if ik_kv_karte.to_s != ''
              xml["kod"].IK_Krankenversicherung ik_kv_karte
            end
            if fallnummer.to_s != ''
              xml["kod"].Fallnummer fallnummer
            end
          }
        end

        def rv_id(
          xml,
          versicherungsnummer,
          massnahmenummer,
          berechtigtennummer,
          zuordnung_mitarbeiter
        )
        xml.send("kod:Fall_ID_RV") {
          xml["kod"].Versicherungsnummer versicherungsnummer

          if massnahmenummer.to_s != ''
            xml["kod"].Massnahmenummer massnahmenummer
          end
          if berechtigtennummer.to_s != ''
            xml["kod"].Berechtigtennummer berechtigtennummer
          end
          if zuordnung_mitarbeiter.to_s != ''
            xml["kod"].Zuordnung_Bearbeiter zuordnung_mitarbeiter
          end
        }
        end

        private

        def bool_value(value)
          if value
            'J'
          else
            'N'
          end
        end

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
