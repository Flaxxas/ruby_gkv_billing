module RubyGkvBilling
  module Security
    class KeyStore
      require 'openssl'

      KEY_URL = 'https://trustcenter-data.itsg.de/dale/annahme-rsa4096.key'.freeze

      START_DATA = "\n-----BEGIN CERTIFICATE-----\n"
      END_DATA = "\n-----END CERTIFICATE-----\n"

      def search_certificate(ik_number)
        certificates.select { |c| c.subject.to_is.include?("OU=IK#{ik_number}") }.last
      end

      def certificates
        @certificates
      end


      def import_certificates(certificate_file)
        blob = IO.binread(certificate_file)

        @certificates = []

        # windows new lines
        blobs = blob.split("\r\n\r\n")
        blobs.each do |cert_content|
          crt = START_DATA
          crt << cert_content
          crt << END_DATA

          cert = OpenSSL::X509::Certificate.new(crt)
          @certificates << cert
        end

        @certificates
      end
    end
  end
end
