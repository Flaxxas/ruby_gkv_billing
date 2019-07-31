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
      let(:private_key) { File.join(RubyGkvBilling.root, "spec/examples/private_1234567_key.pem") }
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
    let(:crt) { File.join(RubyGkvBilling.root, "spec/examples/certificate_1234567.pem") }
    subject { RubyGkvBilling::Security::Certification.open_crt(crt) }
    let(:private_key) { File.join(RubyGkvBilling.root, "spec/examples/private_1234567_key.pem") }
    let(:key) { RubyGkvBilling::Security::Certification.open_key(private_key) }

    it {
      expect(subject.public_key.to_s).to eq(key.public_key.to_s)
    }
  end
end
