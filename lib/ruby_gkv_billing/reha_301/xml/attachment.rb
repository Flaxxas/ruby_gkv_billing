module RubyGkvBilling
  module Reha301
    module Xml
      class Attachment
        def initialize(file_path, filename: nil, medical: false)
          @file_path = file_path

          @filename = filename
          @medical = medical
        end

        def filename_value
          if @filename.to_s != ''
            @filename
          else
            File.basename(@file_path)
          end
        end

        def dateiart_value
          filename_value.split('.').last.upcase
        end

        def to_xml(xml)
          xml.send("bty:Dokument") {
            xml["bty"].Dateiart dateiart_value
            xml["bty"].Dateigroesse File.size(@file_path)
            xml["bty"].medizinischesDokument medical_value
            xml["bty"].Datei Base64.encode64(File.read(@file_path))
          }
        end

        def medical_value
          if @medical
            'J'
          else
            'N'
          end
        end
      end
    end
  end
end
