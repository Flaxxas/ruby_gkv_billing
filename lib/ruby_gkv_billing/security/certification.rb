# https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_16_-_Security-Schnittstelle~1.pdf
# 4.2 + 5.8
module RubyGkvBilling
  module Security
    module Certification
      require 'openssl'

      TRUST_CENTER_WORK = 'ITSG TrustCenter fuer Arbeitgeber'
      TRUST_CENTER_SERVICE = 'ITSG TrustCenter fuer sonstige Leistungserbringer'
      TRUST_CENTER_HOSPITAL = 'DKTIG TrustCenter fuer Krankenhaeuser und Leistungserbringer PKC'

      # ersten 8 Stellen der IK
      def self.create_key!(ik_number, path)
        key = OpenSSL::PKey::RSA.new(4096)
        name = ik_number.to_s[0..7]

        File.open(File.join(path, "private_#{name}_key.pem"), 'w') do |io|
          io.write(key.to_pem)
        end
        File.open(File.join(path, "public_#{name}_key.pem"), 'w') do |io|
          io.write(key.public_key.to_pem)
        end

        key
      end

      def self.open_key(path)
        private_key = File.read(path)
        OpenSSL::PKey::RSA.new(private_key)
      end

      def self.open_crt(path)
        certificate = File.read(path)
        OpenSSL::X509::Certificate.new(certificate)
      end

      def self.open_request(path)
        certificate = File.read(path)
        OpenSSL::X509::Request.new(certificate)
      end

      # 4.4.4
      def self.create_certificate_request!(
        path,
        ik_number,
        organisation_unit_name,
        common_name,
        key: nil,
        organisation_name: TRUST_CENTER_SERVICE,
        country: 'DE',
        prefix: 'IK'
      )
        key = create_key!(ik_number, path) if key.nil?
        key_name = ik_number.to_s[0..7]

        csr = OpenSSL::X509::Request.new
        csr.version = 0
        cert_name = [ # 4.2
          ['C', country],
          ['O', organisation_name],
          ['OU', organisation_unit_name], # Name der Institution (Firmenname des Leistungserbringers oder des Arbeitgebers)
          ['OU', "#{prefix}#{ik_number}"], # Institutionskennzeichen
          ['CN', common_name] # Ansprechpartner
        ]

        extensions.each do |attr|
          csr.add_attribute(attr)
        end

        csr.subject = OpenSSL::X509::Name.new(cert_name)
        csr.public_key = key.public_key
        csr.sign key, OpenSSL::Digest::SHA1.new

        File.open(File.join(path, "#{key_name}.p10"), 'w') do |io|
          io.write csr.to_pem
        end

        csr
      end

      # 5.8.3.4
      def self.extensions
        return @extensions if @extensions

        exts = [
          ['basicConstraints', 'CA:FALSE', false]
        ]

        ef = OpenSSL::X509::ExtensionFactory.new
        exts = exts.map do |ext|
          ef.create_extension(*ext)
        end

        attrval = OpenSSL::ASN1::Set([OpenSSL::ASN1::Sequence(exts)])

        @extensions = [
          OpenSSL::X509::Attribute.new('extReq', attrval),
          OpenSSL::X509::Attribute.new('msExtReq', attrval)
        ]
      end
    end
  end
end
