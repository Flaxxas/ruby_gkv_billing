# https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_16_-_Security-Schnittstelle~1.pdf
# Kapitel 3
module RubyGkvBilling
  module Security
    module Encryption
      require 'openssl'
      require 'base64'

      def self.call_jar(params)
        system("java -jar -Dfile.encoding=UTF-8 #{RubyGkvBilling.file_path("lib/ruby_gkv_billing/security/bin/Nebraska-1.0-SNAPSHOT.jar")} #{params}")
      end

      def self.call_jar_help
        call_jar("-h")
      end

      def self.encrypt(input_file_path, private_key_path, certificate_path, target_ik, basedir = nil)
        basedir_arg = "-b #{basedir}" if basedir
        call_jar("-enc -p #{private_key_path} -c #{certificate_path} -t #{target_ik} -i #{input_file_path} -dl #{basedir_arg}")
      end

      def self.decrypt(input_file_path, private_key_path, certificate_path, basedir = nil)
        basedir_arg = "-b #{basedir}" if basedir
        call_jar("-dec -p #{private_key_path} -c #{certificate_path} -i #{input_file_path} -dl #{basedir_arg}")
      end

      # 2.1.2 RSA-PSS + 3.2.1
      def self.sign(private_key, data, encode: true)
        signature =
          private_key.sign_pss(
            'SHA256',
            data,
            salt_length: 20,
            mgf1_hash: 'SHA256'
          )

        signature = Base64.encode64(signature) if encode

        signature
      end

      def self.verify(key, signature, data, decode: true)
        signature = Base64.decode64(signature) if decode
        key.verify_pss(
          'SHA256',
          signature,
          data,
          salt_length: 20,
          mgf1_hash: 'SHA256'
        )
      end

      # 2.1.3
      def self.cipher
        OpenSSL::Cipher::AES256.new(:CBC)
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
