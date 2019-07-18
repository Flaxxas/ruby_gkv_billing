module RubyGkvBilling
  module Edifact
    class Message
      class Slla
        class Other < RubyGkvBilling::Edifact::Message::Slla
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
              einzel_rechungs_nummer,
              rechnungs_art,
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
              identifikationsmerkmal,

              #OPTIONAL => REC_SEGMENT
              datum: Time.now
            )

            super(
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
              einzel_rechungs_nummer,
              rechnungs_art,
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
              identifikationsmerkmal,

              #OPTIONAL => REC_SEGMENT
              datum: datum
            )
          end
        end
      end
    end
  end
end
