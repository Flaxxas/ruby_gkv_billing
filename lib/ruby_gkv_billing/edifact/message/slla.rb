module RubyGkvBilling
  module Edifact
    class Message
      # 5.5.3
      class Slla < RubyGkvBilling::Edifact::Message

        def initialize(
          nachrichten_ref_nummer,
          #FKT_SEGMENT
          verarbeitungskennzeichnung,
          ik_leistungserbringer,
          ik_kostenträger,
          ik_krankenkasse,
          ik_rechnungssteller,
          #REC_SEGMENT
          rechnungsnummer,
          sammel_rechnungsnummer,
          einzel_rechnungs_nummer,
          rechnungs_art,

          #OPTIONAL => REC_SEGMENT
          datum: Time.now
        )

          #FKT_SEGMENT
          @verarbeitungskennzeichnung = verarbeitungskennzeichnung
          @ik_leistungserbringer = ik_leistungserbringer
          @ik_kostenträger = ik_kostenträger
          @ik_krankenkasse = ik_krankenkasse
          @ik_rechnungssteller = ik_rechnungssteller
          #REC_SEGMENT
          @rechnungsnummer = rechnungsnummer
          @sammel_rechnungsnummer = sammel_rechnungsnummer
          @einzel_rechnungs_nummer = einzel_rechnungs_nummer
          @datum = datum
          @rechnungs_art = rechnungs_art

          super(nachrichten_ref_nummer, "SLLA")

          self.<< fkt_segment
          self.<< rec_segment
        end

        def fkt_segment
          fkt_segment = RubyGkvBilling::Edifact::Segment.new("FKT")
          fkt_segment << @verarbeitungskennzeichnung
          fkt_segment << @ik_leistungserbringer
          fkt_segment << @ik_kostenträger
          fkt_segment << @ik_krankenkasse
          fkt_segment << @ik_rechnungssteller

          fkt_segment
        end

        def rec_segment
          rec_segment = RubyGkvBilling::Edifact::Segment.new("REC")
          rec_segment << @rechnungsnummer
          rec_segment << @sammel_rechnungsnummer
          rec_segment << @einzel_rechnungs_nummer
          rec_segment << @datum.strftime("%Y%m%e")
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
            gesamt_zuzahlung,
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

          inv_segment = RubyGkvBilling::Edifact::Message::Slla::Inv.new(
            #INV_SEGMENT
            versicherten_nummer,
            versicherten_status,
            beleg_info,
            beleg_nummer,
            besondere_versorgungsform,
            #URI_SEGMENT
            gesamt_zuzahlung,
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
