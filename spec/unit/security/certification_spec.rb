RSpec.describe RubyGkvBilling::Security::Certification do
  require 'tmpdir'

  describe "creating key" do
    let(:key) { RubyGkvBilling::Security::Certification.create_key!("1234567", Dir.tmpdir)}
    let(:private_key) { File.join(Dir.tmpdir, "private_1234567_key.pem") }
    let(:public_key) { File.join(Dir.tmpdir, "public_1234567_key.pem") }

    before do
      key
    end

    it {
      expect(key.to_pem).to include("PRIVATE KEY")
    }

    it {
      expect(File.exist?(private_key)).to be_truthy
    }

    it {
      expect(File.exist?(public_key)).to be_truthy
    }

    context "opening key" do
      subject { RubyGkvBilling::Security::Certification.open_key(private_key) }

      it {
        expect(subject.to_pem).to include("PRIVATE KEY")
      }
    end

    after do
      File.delete(private_key) if File.exist?(private_key)
      File.delete(public_key) if File.exist?(public_key)
    end
  end

  describe "creating certificate request" do
    context "with existing key" do
      let(:crt) { RubyGkvBilling::Security::Certification.create_certificate_request!(
        Dir.tmpdir,
        "1234567",
        "OrgaName",
        "Ansprechpartner",
        key: key
        )
      }
      let(:private_key) { RubyGkvBilling.file_path("spec/examples/private_1234567_key.pem") }
      let(:key) { RubyGkvBilling::Security::Certification.open_key(private_key) }
      let(:crt_path) { File.join(Dir.tmpdir, "1234567.p10") }

      before do
        crt
      end

      it {
        expect(crt.subject.to_s).to eq("/C=DE/O=ITSG TrustCenter fuer sonstige Leistungserbringer/OU=OrgaName/OU=IK1234567/CN=Ansprechpartner")
      }

      it {
        expect(RubyGkvBilling::Security::Certification.hash_code(crt.public_key)).to eq("e9cdbad10a20ab821a83faed82da50f405a70a998d267212dd689da2f158d18e")
      }

      it {
        expect(crt.public_key.to_s).to eq(key.public_key.to_s)
      }

      it {
        expect(crt.verify(crt.public_key)).to be_truthy
      }
    end

    context "with new key" do
      let(:crt) { RubyGkvBilling::Security::Certification.create_certificate_request!(
        Dir.tmpdir,
        "1234567",
        "OrgaName",
        "Ansprechpartner"
        )
      }
      let(:private_key) { File.join(Dir.tmpdir, "private_1234567_key.pem") }
      let(:public_key) { File.join(Dir.tmpdir, "public_1234567_key.pem") }
      let(:crt_path) {
        File.join(Dir.tmpdir, "1234567.p10")
      }

      before do
        crt
      end

      it {
        expect(File.exist?(private_key)).to be_truthy
      }

      it {
        expect(File.exist?(public_key)).to be_truthy
      }

      it {
        expect(crt.subject.to_s).to eq("/C=DE/O=ITSG TrustCenter fuer sonstige Leistungserbringer/OU=OrgaName/OU=IK1234567/CN=Ansprechpartner")
      }

      it {
        expect(crt.public_key).not_to be_nil
      }

      it {
        expect(crt.verify(crt.public_key)).to be_truthy
      }

      after do
        File.delete(private_key) if File.exist?(private_key)
        File.delete(public_key) if File.exist?(public_key)
      end
    end

    after do
      File.delete(crt_path) if File.exist?(crt_path)
    end
  end

  describe "extensions" do
    subject { RubyGkvBilling::Security::Certification.extensions }

    it {
      expect(subject.size).to eq(2)
    }
  end

  describe "opening crt" do
    let(:crt) { RubyGkvBilling.file_path("spec/examples/certificate_1234567.pem") }
    subject { RubyGkvBilling::Security::Certification.open_crt(crt) }
    let(:private_key) { RubyGkvBilling.file_path("spec/examples/private_1234567_key.pem") }
    let(:key) { RubyGkvBilling::Security::Certification.open_key(private_key) }

    it {
      expect(subject.public_key.to_s).to eq(key.public_key.to_s)
    }
  end
  describe "ssl", focus: true do
    subject{ RubyGkvBilling::Security::Certification }
    let(:ik_number){ "123456" }
    let(:path){ RubyGkvBilling.file_path("spec/examples/ssl/") }
    let(:config){ RubyGkvBilling.file_path("spec/examples/ssl/itsg.config") }

    context "create_private_key" do
      let(:key){ subject.create_private_key(ik_number, path) }

      it {expect(subject.open_key(key).to_pem).to include("PRIVATE KEY")}

      it {expect(File.exist?(key)).to be_truthy}
    end

    context "create_certificate" do
      let(:certificate){ RubyGkvBilling.file_path("spec/examples/ssl/123456.p10.req.pem") }

      it {expect(File.exist?(certificate)).to be_truthy}
    end

    context "create_public_key" do
      let(:key){ subject.create_public_key(ik_number, path, config_file_path: config) }

      it {expect(subject.open_key(key).to_pem).to include("PUBLIC KEY")}

      it {expect(File.exist?(key)).to be_truthy}
    end

    context "extract_pkey" do
      let(:pkey){ subject.extract_pkey(ik_number, path) }

      it {expect(File.exist?(pkey)).to be_truthy}
    end

    context "sha1_code" do
      let(:key) { RubyGkvBilling.file_path("spec/examples/ssl/123456.pub.key.pem") }
      let(:example){ RubyGkvBilling.file_path("spec/examples/ssl/example.pub.key.pem") }
      let(:sha1_hash) { "52dc9ec11ee8b0b235e23744e68d0b91286e4843"}

      it {expect(subject.sha1_code(key)).to eq(subject.sha1_code(example))}

      it {
        expect(subject.sha1_code(key)).to eq(sha1_hash)
      }
    end

    context "p7c to pem" do
      let(:p7c) { RubyGkvBilling.file_path("spec/examples/certificate_1234567.p7c") }
      let(:crt) { RubyGkvBilling.file_path("spec/examples/certificate_1234567.pem") }

      it {expect(subject.convert_p7c_to_pem(p7c)).to include("CERTIFICATE")}
      it {expect(subject.convert_p7c_to_pem(p7c)).to eq(File.read(crt))}
    end

    after(:all) do
      File.delete(RubyGkvBilling.file_path("spec/examples/ssl/123456.prv.key.pem"))
      # Example Certificate: File.delete(RubyGkvBilling.file_path("spec/examples/ssl/123456.p10.req.pem"))
      File.delete(RubyGkvBilling.file_path("spec/examples/ssl/123456.pub.key.pem"))
      File.delete(RubyGkvBilling.file_path("spec/examples/ssl/123456.pkey"))
    end
  end
end
