module RubyGkvBilling
  module Edifact
    class Message
      # 5.5.2
      class Slga < RubyGkvBilling::Edifact::Message

        def initialize(
          nachrichten_ref_nummer,
          #FKT_SEGMENT
          verarbeitungskennzeichnung,
          ik_rechnungssteller,
          ik_kostentraeger,
          ik_krankenkasse,
          ik_datei_sender,
          #REC_SEGMENT
          sammel_rechnungsnummer,
          einzel_rechnungs_nummer,
          rechnungs_art,
          #GES_SEGMENT
          status,
          gesamt_rechnungsbetrag,
          gesamt_bruttobetrag,
          gesamt_zuzahlung,
          #NAM_SEGMENT
          name1,
          name4,
          #OPTIONAL => FKT_SEGMENT
          sammelrechnung: "N",
          #OPTIONAL => REC_SEGMENT
          datum: Time.now,
          #OPTIONAL => UST_SEGMENT
          steuernummer: nil,
          ust_befreiung: 'J',
          #OPTIONAL => SKO_SEGMENT
          skonto_prozent: nil,
          zahlungsziel: nil,
          #OPTIONAL => NAM_SEGMENT
          name2: nil,
          name3: nil
        )

          #FKT_SEGMENT
          @verarbeitungskennzeichnung = verarbeitungskennzeichnung #Schluessel Verarbeitungskennzeichen Anlage 3 Abschnitt 8.1.7
          @sammelrechnung = sammelrechnung #'N' Wenn Sammelrechnung
          @ik_rechnungssteller = ik_rechnungssteller #IK des Leistungserbringers, wenn nicht: Abrechnung ueber Abrechnungsstelle mit Inkassovollmacht => IK der Abrechnungsstelle
          @ik_kostentraeger = ik_kostentraeger
          @ik_krankenkasse = ik_krankenkasse
          @ik_datei_sender = ik_datei_sender
          #REC_SEGMENT
          @sammel_rechnungsnummer = sammel_rechnungsnummer #Zusaetzlich Einzel-Rechnungsnummer angeben
          @einzel_rechnungs_nummer = einzel_rechnungs_nummer
          @datum = datum
          @rechnungs_art = rechnungs_art #Siehe Schluessel Rechnungsart Anlage 3 Abschnitt 8.1.4.
          #UST_SEGMENT
          @steuernummer = steuernummer
          @ust_befreiung = ust_befreiung #'J' wenn befreit gem. § 4 UStG
          #SKO_SEGMENT
          @skonto_prozent = skonto_prozent
          @zahlungsziel = zahlungsziel #Zahlungsziel in Tagen
          #GES_SEGMENT
          @status = status #Siehe Schlüssel Summenstatus Anlage 3 Abschnitt 8.1.6
          @gesamt_rechnungsbetrag = gesamt_rechnungsbetrag
          @gesamt_bruttobetrag = gesamt_bruttobetrag
          @gesamt_zuzahlung = gesamt_zuzahlung
          #NAM_SEGMENT
          @name1 = name1 #Name bzw. Firmenbezeichnung des Rechnungsstellers
          @name2 = name2 #ggf. Ansprechpartner und Telefonnummer
          @name3 = name3 #ggf. Ansprechpartner und Telefonnummer
          @name4 = name4 #E-Mail-Adresse;

          super(nachrichten_ref_nummer, "SLGA")

          self.<< fkt_segment
          self.<< rec_segment
          if @sammelrechnung == "N"
            self.<< ust_segment
          end
          self.<< sko_segment
          self.<< ges_segment
          self.<< nam_segment
        end

        def fkt_segment
          fkt_segment = RubyGkvBilling::Edifact::Segment.new("FKT")
          fkt_segment << @verarbeitungskennzeichnung
          fkt_segment << @sammelrechnung
          fkt_segment << @ik_rechnungssteller
          fkt_segment << @ik_kostentraeger
          fkt_segment << @ik_krankenkasse
          fkt_segment << @ik_datei_sender

          fkt_segment
        end

        def rec_segment
          rec_segment = RubyGkvBilling::Edifact::Segment.new("REC")
          rec_segment.add_splitted_element([
              @sammel_rechnungsnummer,
              @einzel_rechnungs_nummer
            ])
          rec_segment << @datum.strftime("%Y%m%e")
          rec_segment << @rechnungs_art

          rec_segment
        end

        def ust_segment
          ust_segment = RubyGkvBilling::Edifact::Segment.new("UST")
          ust_segment << @steuernummer
          ust_segment << @ust_befreiung

          ust_segment
        end

        def sko_segment
          sko_segment = RubyGkvBilling::Edifact::Segment.new("SKO")
          sko_segment << @skonto_prozent
          sko_segment << @zahlungsziel

          sko_segment
        end

        def ges_segment
          ges_segment = RubyGkvBilling::Edifact::Segment.new("GES")
          ges_segment << @status
          ges_segment << @gesamt_rechnungsbetrag
          ges_segment << @gesamt_bruttobetrag
          ges_segment << @gesamt_zuzahlung

          ges_segment
        end

        def nam_segment
          nam_segment = RubyGkvBilling::Edifact::Segment.new("NAM")
          nam_segment << @name1
          if @name2
            nam_segment << @name2
          end
          if @name3
            nam_segment << @name3
          end
          nam_segment << @name4

          nam_segment
        end
      end
    end
  end
end
