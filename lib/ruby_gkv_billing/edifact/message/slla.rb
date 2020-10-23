module RubyGkvBilling
  module Edifact
    class Message
      # 5.5.3
      class Slla < RubyGkvBilling::Edifact::Message

        def initialize(
          #FKT_SEGMENT
          verarbeitungskennzeichnung,
          ik_leistungserbringer,
          ik_kostentraeger,
          ik_krankenkasse,
          ik_rechnungssteller,
          #REC_SEGMENT
          sammel_rechnungsnummer,
          einzel_rechnungs_nummer,
          rechnungs_art,
          #OPTIONAL
          nachrichten_ref_nummer: nil,
          #OPTIONAL => REC_SEGMENT
          datum: Time.now,
          message_version: RubyGkvBilling::Edifact::MESSAGE_VERSION
        )

          #FKT_SEGMENT
          @verarbeitungskennzeichnung = verarbeitungskennzeichnung
          @ik_leistungserbringer = ik_leistungserbringer
          @ik_kostentraeger = ik_kostentraeger
          @ik_krankenkasse = ik_krankenkasse
          @ik_rechnungssteller = ik_rechnungssteller
          #REC_SEGMENT
          @sammel_rechnungsnummer = sammel_rechnungsnummer
          @einzel_rechnungs_nummer = einzel_rechnungs_nummer
          @datum = datum
          @rechnungs_art = rechnungs_art

          super(nachrichten_ref_nummer, "SLLA", message_version: message_version)

          self.<< fkt_segment
          self.<< rec_segment
        end

        def fkt_segment
          fkt_segment = RubyGkvBilling::Edifact::Segment.new("FKT")
          fkt_segment << @verarbeitungskennzeichnung
          # Freifeld
          fkt_segment << ""
          fkt_segment << @ik_leistungserbringer
          fkt_segment << @ik_kostentraeger
          fkt_segment << @ik_krankenkasse
          if @rechnungs_art.to_s == "3"
            fkt_segment << @ik_rechnungssteller
          else
            fkt_segment << ""
          end
          fkt_segment
        end

        def rec_segment
          rec_segment = RubyGkvBilling::Edifact::Segment.new("REC")
          rec_segment.add_splitted_element([
              @sammel_rechnungsnummer,
              @einzel_rechnungs_nummer
            ])
          rec_segment << @datum.strftime("%Y%m%d")
          rec_segment << @rechnungs_art

          rec_segment
        end

        def add_inv_segment(
            #INV_SEGMENT
            versicherten_nummer,
            versicherten_status,
            beleg_info,
            beleg_nummer,
            besondere_versorgungsform,
            #URI_SEGMENT
            urspruengliche_ik_leistungserbringer,
            urpsruengliche_sammel_rechnungsnummer,
            urpsruengliche_einzel_rechnungsnummer,
            urpsruengliches_rechnungsdatum,
            urpsruengliche_belegnummer,
            #NAD_SEGMENT
            vers_nachname,
            vers_vorname,
            vers_gebdatum,
            vers_strasse,
            vers_plz,
            vers_ort,
            vers_kennzeichen,
            #IMG_SEGMENT
            abrechnungsjahr,
            abrechnungsmonat,
            identifikationsmerkmal
          )

          #8.1.7 regulaere Abrechnung
          if @verarbeitungskennzeichnung == "01"
            urspruengliche_ik_leistungserbringer = nil
          end

          inv_segment = RubyGkvBilling::Edifact::Message::Slla::Inv.new(
            #INV_SEGMENT
            versicherten_nummer,
            versicherten_status,
            beleg_info,
            beleg_nummer,
            besondere_versorgungsform,
            #URI_SEGMENT
            urspruengliche_ik_leistungserbringer,
            urpsruengliche_sammel_rechnungsnummer,
            urpsruengliche_einzel_rechnungsnummer,
            urpsruengliches_rechnungsdatum,
            urpsruengliche_belegnummer,
            #NAD_SEGMENT
            vers_nachname,
            vers_vorname,
            vers_gebdatum,
            vers_strasse,
            vers_plz,
            vers_ort,
            vers_kennzeichen,
            #IMG_SEGMENT
            abrechnungsjahr,
            abrechnungsmonat,
            identifikationsmerkmal
          )
          inv_segment.segments.each do |segment|
            self.<< segment
          end
        end
      end
    end
  end
end
