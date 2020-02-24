module RubyGkvBilling
  module Edifact
    class Message
      class Slla
        # INV ist ein Abrechnungsfall
        class Inv

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
            identifikationsmerkmal
          )
            #INV_SEGMENT
            @versicherten_nummer = versicherten_nummer
            @versicherten_status = versicherten_status.to_s.rjust(5, "0")[0..4]
            @beleg_info = beleg_info
            @beleg_nummer = beleg_nummer
            @besondere_versorgungsform = besondere_versorgungsform
            #URI_SEGMENT
            @urspruengliche_ik_leistungserbringer = urspruengliche_ik_leistungserbringer
            @urpsruengliche_sammel_rechnungsnummer = urpsruengliche_sammel_rechnungsnummer
            @urpsruengliche_einzel_rechnungsnummer = urpsruengliche_einzel_rechnungsnummer
            @urpsruengliches_rechnungsdatum = urpsruengliches_rechnungsdatum
            @urpsruengliche_belegnummer = urpsruengliche_belegnummer
            #NAD_SEGMENT
            @vers_nachname = vers_nachname
            @vers_vorname = vers_vorname
            @vers_gebdatum = vers_gebdatum
            @vers_strasse = vers_strasse
            @vers_plz = vers_plz
            @vers_ort = vers_ort
            @vers_kennzeichen = vers_kennzeichen
            #IMG_SEGMENT
            @abrechnungsjahr = abrechnungsjahr
            @abrechnungsmonat = abrechnungsmonat
            @identifikationsmerkmal = identifikationsmerkmal

            @segments = []
            @diagnoses = []

            self.<< inv_segment
            if @urspruengliche_ik_leistungserbringer.to_s != ""
              self.<< uri_segment
            end
            self.<< nad_segment
            if @abrechnungsjahr.to_s != ""
              self.<< img_segment
            end
          end

          def <<(segment)
            @segments << segment
          end

          def segments
            @segments
          end

          def diagnoses
            @diagnoses
          end

          def inv_segment
            inv_segment = RubyGkvBilling::Edifact::Segment.new("INV")
            inv_segment << @versicherten_nummer
            inv_segment << @versicherten_status
            inv_segment << @beleg_info
            inv_segment << @beleg_nummer
            inv_segment << @besondere_versorgungsform

            inv_segment
          end

          def uri_segment
            uri_segment = RubyGkvBilling::Edifact::Segment.new("URI")
            uri_segment << @urspruengliche_ik_leistungserbringer
            uri_segment << @urpsruengliche_sammel_rechnungsnummer
            uri_segment << @urpsruengliche_einzel_rechnungsnummer
            uri_segment << @urpsruengliches_rechnungsdatum
            uri_segment << @urpsruengliche_belegnummer

            uri_segment
          end

          def nad_segment
            nad_segment = RubyGkvBilling::Edifact::Segment.new("NAD")
            nad_segment << @vers_nachname
            nad_segment << @vers_vorname
            nad_segment << @vers_gebdatum.strftime("%Y%m%d")
            nad_segment << @vers_strasse
            nad_segment << @vers_plz
            nad_segment << @vers_ort
            nad_segment << @vers_kennzeichen

            nad_segment
          end

          def img_segment
            img_segment = RubyGkvBilling::Edifact::Segment.new("IMG")
            img_segment << @abrechnungsjahr
            img_segment << @abrechnungsmonat
            img_segment << @identifikationsmerkmal

            img_segment
          end

          def add_diagnose(diagnoseschluessel,
                           diagnosetext)
            @diagnoses << dia_segment(diagnoseschluessel,
                                diagnosetext)
          end

          def dia_segment(diagnoseschluessel,
                          diagnosetext)

            dia_segment = RubyGkvBilling::Edifact::Segment.new("DIA")
            dia_segment << diagnoseschluessel
            dia_segment << diagnosetext

            dia_segment
          end
        end
      end
    end
  end
end
