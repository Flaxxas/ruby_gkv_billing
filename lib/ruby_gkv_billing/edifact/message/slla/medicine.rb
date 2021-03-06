module RubyGkvBilling
  module Edifact
    class Message
      class Slla
        # 5.5.3.3
        class Medicine < RubyGkvBilling::Edifact::Message::Slla::Inv
          def initialize(
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
              identifikationsmerkmal,
              #ZHE_SEGMENT
              zuzahlungskennzeichen,
              kennzeichen_verordnungsart,
              kennzeichen_verordnungsbesonderheiten,
              unfallkennzeichen,
              kennzeichen_bvg,
              therapie_bericht,
              hausbesuch,
              leitsymptomatik,
              individuelle_leitsymptomatik,
              dringlich,
              bereich,
              #BES_SEGMENT
              ges_brutto,
              ges_gesetzliche_zuzahlung,
              ges_prozentuale_zuzahlung,
              pauschale_zuzahlung,
              #GZF_SEGMENT
              forderung_gesetzlich,
              forderung_prozentual,
              forderung_pauschal,
              #OPTIONAL ZHE_SEGMENT
              behandlungsbeginn: Time.now,
              diagnosegruppe: "9999",
              arztnummer: "999999999",
              betriebsstaetten_nr: "999999999",
              verordnungs_datum: Time.now,
              frequenz: nil,
              #OPTIONAL SKZ_SEGMENT
              genehmigungskennzeichen: nil,
              genehmigungsart: nil,
              datum_genehmigung: Time.now,
              message_version: RubyGkvBilling::Edifact::MESSAGE_VERSION,
              pauschale_korrektur: nil
            )

            super(
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
              identifikationsmerkmal,
              message_version: message_version
            )

            #ZHE_SEGMENT
            if betriebsstaetten_nr.to_s == ""
              @betriebsstaetten_nr = "999999999"
            else
              @betriebsstaetten_nr = betriebsstaetten_nr
            end
            if arztnummer.to_s == ""
              @arztnummer = "999999999"
            else
              @arztnummer = arztnummer
            end
            @verordnungs_datum = verordnungs_datum
            @zuzahlungskennzeichen = zuzahlungskennzeichen
            @diagnosegruppe = diagnosegruppe
            @frequenz = frequenz

            @kennzeichen_verordnungsart =
              if kennzeichen_verordnungsart.to_s == ""
                "99"
              else
                kennzeichen_verordnungsart
              end

            @kennzeichen_verordnungsbesonderheiten = kennzeichen_verordnungsbesonderheiten
            @unfallkennzeichen = unfallkennzeichen
            @kennzeichen_bvg = kennzeichen_bvg
            @behandlungsbeginn = behandlungsbeginn
            @therapie_bericht = therapie_bericht
            @hausbesuch = hausbesuch
            @leitsymptomatik = leitsymptomatik
            @individuelle_leitsymptomatik = individuelle_leitsymptomatik
            @dringlich = dringlich
            @bereich = bereich
            #SKZ_SEGMENT
            @genehmigungskennzeichen = genehmigungskennzeichen
            @datum_genehmigung = datum_genehmigung
            @genehmigungsart = genehmigungsart
            #BES_SEGMENT
            @ges_brutto = ges_brutto
            @ges_gesetzliche_zuzahlung = ges_gesetzliche_zuzahlung
            @ges_prozentuale_zuzahlung = ges_prozentuale_zuzahlung
            @pauschale_zuzahlung = pauschale_zuzahlung
            #GZF_SEGMENT
            @forderung_gesetzlich = forderung_gesetzlich
            @forderung_prozentual = forderung_prozentual
            @forderung_pauschal = forderung_pauschal

            @pauschale_korrektur = pauschale_korrektur

            @ehes = []
          end

          def final_segments
            elements = []

            elements << skz_segment if @genehmigungskennzeichen.to_s != ""

            #TODO lese verarbeitungskennzeichen aus
            if @forderung_gesetzlich.to_s != ""
              elements << gzf_segment
            else
              elements << bes_segment
            end

            elements
          end

          # ueberschreiben fuer eigene Struktur
          def segments
            @segments + @ehes + [zhe_segment] + @diagnoses + final_segments
          end

          def add_ehe_segment(
            #EHE_SEGMENT
            abrechnungscode,
            tarifkennzeichen,
            leistungs_art,
            menge,
            einzelbetrag,
            zuzahlung,
            kilometer,
            #TXT_SEGMENT
            text: nil,
            #MWS_SEGMENT
            kennzeichen_mws: nil,
            betrag_mws: nil,
            #OPTIONAL EHE_SEGMENT
            datum_leistungserbringung: Time.now
          )

            @ehes << ehe_segment(
              abrechnungscode,
              tarifkennzeichen,
              leistungs_art,
              menge,
              einzelbetrag,
              datum_leistungserbringung,
              zuzahlung,
              kilometer
            )

            @ehes << txt_segment(
              text
            ) if text.to_s != ""

            @ehes << mws_segment(
              kennzeichen_mws,
              betrag_mws
            ) if kennzeichen_mws && betrag_mws
          end

          def ehe_segment(
            abrechnungscode,
            tarifkennzeichen,
            leistungs_art,
            menge,
            einzelbetrag,
            datum_leistungserbringung,
            zuzahlung,
            kilometer
          )

            ehe_segment = RubyGkvBilling::Edifact::Segment.new("EHE")
            ehe_segment.add_splitted_element([
              abrechnungscode,
              tarifkennzeichen
            ])
            ehe_segment << leistungs_art
            ehe_segment.add_float(menge)
            ehe_segment.add_float(einzelbetrag)
            ehe_segment << datum_leistungserbringung.strftime("%Y%m%d")
            ehe_segment.add_float(zuzahlung)
            ehe_segment << kilometer

            ehe_segment
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
            mws_segment.add_float(betrag_mws)

            mws_segment
          end

          def zhe_segment

            zhe_segment = RubyGkvBilling::Edifact::Segment.new("ZHE")
            zhe_segment << @betriebsstaetten_nr
            zhe_segment << @arztnummer
            zhe_segment << @verordnungs_datum.strftime("%Y%m%d")
            zhe_segment << @zuzahlungskennzeichen
            zhe_segment << @diagnosegruppe
            zhe_segment << @kennzeichen_verordnungsart
            zhe_segment << @kennzeichen_verordnungsbesonderheiten
            zhe_segment << @unfallkennzeichen
            zhe_segment << @kennzeichen_bvg
            if @behandlungsbeginn.to_s != ""
              zhe_segment << @behandlungsbeginn.strftime("%Y%m%d")
            else
              zhe_segment << ""
            end
            zhe_segment << @therapie_bericht
            zhe_segment << @hausbesuch
            zhe_segment << @leitsymptomatik
            zhe_segment << @individuelle_leitsymptomatik
            zhe_segment << @dringlich
            zhe_segment << @bereich
            if @frequenz != nil
              zhe_segment << @frequenz
            end

            zhe_segment
          end

          def skz_segment

            skz_segment = RubyGkvBilling::Edifact::Segment.new("SKZ")
            skz_segment << @genehmigungskennzeichen
            skz_segment << @datum_genehmigung.strftime("%Y%m%d")
            skz_segment << @genehmigungsart

            skz_segment
          end

          def bes_segment

            bes_segment = RubyGkvBilling::Edifact::Segment.new("BES")
            bes_segment.add_float(@ges_brutto)
            bes_segment.add_float(@ges_gesetzliche_zuzahlung)
            bes_segment.add_float(@ges_prozentuale_zuzahlung)
            bes_segment.add_float(@pauschale_zuzahlung)

            bes_segment
          end


          def gzf_segment
            gzf_segment = RubyGkvBilling::Edifact::Segment.new("GZF")
            gzf_segment.add_float(@forderung_gesetzlich)
            gzf_segment.add_float(@forderung_prozentual)
            gzf_segment.add_float(@forderung_pauschal)

            gzf_segment
          end
        end
      end
    end
  end
end
