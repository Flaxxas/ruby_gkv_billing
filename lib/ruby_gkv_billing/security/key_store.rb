module RubyGkvBilling
  module Security
    class KeyStore
      require 'openssl'
      require 'net/http'

      KEY_FILE = 'annahme-rsa4096.key'.freeze
      KEY_URL = "https://trustcenter-data.itsg.de/dale/#{KEY_FILE}".freeze

      START_DATA = "\n-----BEGIN CERTIFICATE-----\n".freeze
      END_DATA = "\n-----END CERTIFICATE-----\n".freeze

      def initialize(certificate_path: RubyGkvBilling.root)
        @certificate_path = certificate_path

        download_new_certificates unless File.exist?(certificate_file)
        import_certificates
      end

      def search_certificate(ik_number)
        certificates.select { |c| c.subject.to_s.include?("OU=IK#{ik_number}") }.last
      end

      def certificates
        @certificates
      end

      def certificate_file
        @certificate_file ||= File.join(@certificate_path, KEY_FILE)
      end

      def import_certificates
        blob = IO.binread(certificate_file)

        @certificates = []

        # windows new lines
        blobs = blob.split("\r\n\r\n")
        blobs.each do |cert_content|
          crt = "#{START_DATA}"
          crt << cert_content
          crt << END_DATA

          cert = OpenSSL::X509::Certificate.new(crt)
          @certificates << cert
        end

        @certificates
      end

      def download_new_certificates
        url = URI(KEY_URL)
        content = Net::HTTP.get(url)

        File.write(certificate_file, content)
      end
    end
  end
end
