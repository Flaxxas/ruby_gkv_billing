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

      # https://github.com/ruby/openssl/issues/163
      def self.hash_code(public_key)
        der = public_key.to_der
        asn1 = OpenSSL::ASN1.decode(der)
        rawpubkey = nil

        asn1.value.each {|v|
          if v.tag == 3
            rawpubkey = v.value
          end
        }

        Digest::SHA256.digest(rawpubkey).unpack("H*").first
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
          ['C',   country,                 OpenSSL::ASN1::PRINTABLESTRING],
          ['O',   organisation_name,       OpenSSL::ASN1::PRINTABLESTRING],
          ['OU',  organisation_unit_name,  OpenSSL::ASN1::PRINTABLESTRING], # Name der Institution (Firmenname des Leistungserbringers oder des Arbeitgebers)
          ['OU',  "#{prefix}#{ik_number}", OpenSSL::ASN1::PRINTABLESTRING], # Institutionskennzeichen
          ['CN',  common_name,             OpenSSL::ASN1::PRINTABLESTRING] # Ansprechpartner
        ]

        extensions.each do |attr|
          csr.add_attribute(attr)
        end

        csr.subject = OpenSSL::X509::Name.new(cert_name)
        csr.public_key = key.public_key
        csr.sign key, OpenSSL::Digest::SHA256.new

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

      def self.create_private_key(ik_number, path)
        system("openssl genrsa -out #{path}/#{ik_number}.prv.key.pem 4096")
        return File.join(path, "#{ik_number}.prv.key.pem")
      end

      def self.create_certificate(ik_number, private_key_path, config_file_path: File.join(RubyGkvBilling.root, "lib/ruby_gkv_billing/security/ssl/itsg.config"))
        system("openssl req -new -config #{config_file_path} -key #{private_key_path}/#{ik_number}.prv.key.pem -sha256 -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:32 -out #{private_key_path}/#{ik_number}.p10.req.pem")
        return File.join(private_key_path, "#{ik_number}.p10.req.pem")
      end

      def self.create_public_key(ik_number, private_key_path, config_file_path: File.join(RubyGkvBilling.root, "lib/ruby_gkv_billing/security/ssl/itsg.config"))
        system("openssl req -config #{config_file_path} -in #{private_key_path}/#{ik_number}.p10.req.pem -pubkey -noout -out #{private_key_path}/#{ik_number}.pub.key.pem")
        return File.join(private_key_path, "#{ik_number}.pub.key.pem")
      end

      def self.extract_pkey(ik_number, public_key_path)
        system("openssl asn1parse -in #{public_key_path}/#{ik_number}.pub.key.pem -strparse 19 -out #{public_key_path}/#{ik_number}.pkey -noout")
        return File.join(public_key_path, "#{ik_number}.pkey")
      end

      def self.sha1_code(pkey_path)
        system("openssl dgst -c -sha1 #{pkey_path}")
      end

      def self.generate_keyset!(ik_number, path)
        create_private_key(ik_number, path)
        create_certificate(ik_number, path)
        create_public_key(ik_number, path)
        extract_pkey(ik_number, path)
        sha1_code(File.join(path, "#{ik_number}.pkey"))
      end
    end
  end
end
