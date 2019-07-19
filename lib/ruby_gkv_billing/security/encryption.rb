# https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_16_-_Security-Schnittstelle~1.pdf
# Kapitel 3
module RubyGkvBilling
  module Security
    module Encryption
      require 'openssl'
      require 'base64'

      def self.encrypt(key, data)
        #code
      end

      def self.decrypt(key, encrypted_data)
        #code
      end

      # 2.1.2 RSA-PSS
      def self.sign(private_key, data, encode: true)
        signature =
          private_key.sign_pss(
            'SHA1',
            data,
            salt_length: 20,
            mgf1_hash: 'SHA1'
          )

        signature = Base64.encode64(signature) if encode

        signature
      end

      def self.verify(key, signature, data, decode: true)
        signature = Base64.decode64(signature) if decode
        key.verify_pss(
          'SHA1',
          signature,
          data,
          salt_length: 20,
          mgf1_hash: 'SHA1'
        )
      end

      def self.cipher
        OpenSSL::Cipher::AES256.new
      end

      # 3.2.1.2
      def self.digest
        OpenSSL::Digest::SHA256.new
      end

      # 2.1.1
      def self.hash(data=nil)
        OpenSSL::Digest::SHA256.new(data)
      end
    end
  end
end
