module RubyGkvBilling
  module Edifact
    class Message
      class Slla
        class Other < RubyGkvBilling::Edifact::Message::Slla::Inv
          def initialize(
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
              #BES_SEGMENT
              ges_brutto,
              ges_gesetzliche_zuzahlung,
              ges_prozentuale_zuzahlung,
              pauschale_zuzahlung,
              ges_eigenanteil,
              #OPTIONAL ZUV_SEGMENT
              zuzahlungskennzeichen: nil,
              unfallkennzeichen: nil,
              kennzeichen_bvg: nil,
              kennzeichen_verordnungsbesonderheiten: nil,
              betriebsstätten_nr: "999999999",
              arztnummer: "999999999",
              verordnungs_datum: Time.now,
              #OPTIONAL SKZ_SEGMENT
              genehmigungskennzeichen: nil,
              genehmigungsart: nil,
              datum_genehmigung: Time.now
            )

            super(
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

            @zuzahlungskennzeichen = zuzahlungskennzeichen
            @unfallkennzeichen = unfallkennzeichen
            @kennzeichen_bvg = kennzeichen_bvg
            @kennzeichen_verordnungsbesonderheiten = kennzeichen_verordnungsbesonderheiten
            @ges_brutto = ges_brutto
            @ges_gesetzliche_zuzahlung = ges_gesetzliche_zuzahlung
            @ges_prozentuale_zuzahlung = ges_prozentuale_zuzahlung
            @pauschale_zuzahlung = pauschale_zuzahlung
            @ges_eigenanteil = ges_eigenanteil
            @betriebsstätten_nr = betriebsstätten_nr
            @arztnummer = arztnummer
            @verordnungs_datum = verordnungs_datum
            @genehmigungskennzeichen = genehmigungskennzeichen
            @genehmigungsart = genehmigungsart
            @datum_genehmigung = datum_genehmigung

            self.<< zuv_segment if @betriebsstätten_nr
            self.<< skz_segment if @genehmigungskennzeichen
            self.<< bes_segment

          end

          def add_enf_segment(
            #ENF_SEGMENT
            identifikationsnummer,
            abrechnungscode,
            tarifkennzeichen,
            leistungs_art,
            menge,
            einzelbetrag,
            zuzahlung,
            #SUT_SEGMENT
            kilometer: nil,
            uhrzeit: Time.now,
            uhrzeit_bis: Time.now,
            dauer: nil,
            versorgung_von: Time.now,
            versorgung_bis: Time.now,
            #TXT_SEGMENT
            text: nil,
            #MWS_SEGMENT
            kennzeichen_mws: nil,
            betrag_mws: nil,
            #OPTIONAL ENF_SEGMENT
            datum_leistungserbringung: Time.now
          )

            self.<< enf_segment(
              identifikationsnummer,
              abrechnungscode,
              tarifkennzeichen,
              leistungs_art,
              menge,
              einzelbetrag,
              datum_leistungserbringung,
              zuzahlung
            )

            self.<< sut_segment(
              kilometer,
              uhrzeit,
              uhrzeit_bis,
              dauer,
              versorgung_von,
              versorgung_bis
            ) if kilometer

            self.<< txt_segment(
              text
            ) if text

            self.<< mws_segment(
              kennzeichen_mws,
              betrag_mws
            ) if kennzeichen_mws && betrag_mws
          end

          def enf_segment(
            identifikationsnummer,
            abrechnungscode,
            tarifkennzeichen,
            leistungs_art,
            menge,
            einzelbetrag,
            datum_leistungserbringung,
            zuzahlung
          )

            enf_segment = RubyGkvBilling::Edifact::Segment.new("ENF")
            enf_segment << identifikationsnummer
            enf_segment.add_splitted_element([
                abrechnungscode,
                tarifkennzeichen
              ])
            enf_segment << leistungs_art
            enf_segment << menge
            enf_segment << einzelbetrag
            enf_segment << datum_leistungserbringung.strftime("%Y%m%e")
            enf_segment << zuzahlung

            enf_segment
          end

          def sut_segment(
            kilometer,
            uhrzeit,
            uhrzeit_bis,
            dauer,
            versorgung_von,
            versorgung_bis
          )

            sut_segment = RubyGkvBilling::Edifact::Segment.new("SUT")
            sut_segment << kilometer
            sut_segment << uhrzeit.strftime("%H%M")
            sut_segment << uhrzeit_bis.strftime("%H%M")
            sut_segment << dauer
            sut_segment << versorgung_von.strftime("%Y%m%e")
            sut_segment << versorgung_bis.strftime("%Y%m%e")

            sut_segment
          end

          def txt_segment(text)
            txt_segment = RubyGkvBilling::Edifact::Segment.new("TXT")
            txt_segment << text

            txt_segment
          end

          def mws_segment(
            kennzeichen_mws,
            betrag_mws
          )

            mws_segment = RubyGkvBilling::Edifact::Segment.new("MWS")
            mws_segment << kennzeichen_mws
            mws_segment << betrag_mws

            mws_segment
          end

          def add_diagnose(diagnoseschlüssel,
                           diagnosetext)
            self.<< dia_segment(diagnoseschlüssel,
                                diagnosetext)
          end

          def dia_segment(diagnoseschlüssel,
                          diagnosetext)

            dia_segment = RubyGkvBilling::Edifact::Segment.new("DIA")
            dia_segment << diagnoseschlüssel
            dia_segment << diagnosetext

            dia_segment
          end

          def zuv_segment

            zuv_segment = RubyGkvBilling::Edifact::Segment.new("ZUV")
            zuv_segment << @betriebsstätten_nr
            zuv_segment << @arztnummer
            zuv_segment << @verordnungs_datum.strftime("%Y%m%e")
            zuv_segment << @zuzahlungskennzeichen
            zuv_segment << @unfallkennzeichen
            zuv_segment << @kennzeichen_bvg
            zuv_segment << @kennzeichen_verordnungsbesonderheiten

            zuv_segment
          end

          def skz_segment

            skz_segment = RubyGkvBilling::Edifact::Segment.new("SKZ")
            skz_segment << @genehmigungskennzeichen
            skz_segment << @datum_genehmigung.strftime("%Y%m%e")
            skz_segment << @genehmigungsart

            skz_segment
          end

          def bes_segment

            bes_segment = RubyGkvBilling::Edifact::Segment.new("BES")
            bes_segment << @ges_brutto
            bes_segment << @ges_gesetzliche_zuzahlung
            bes_segment << @ges_prozentuale_zuzahlung
            bes_segment << @pauschale_zuzahlung
            bes_segment << @ges_eigenanteil

            bes_segment
          end
        end
      end
    end
  end
end
