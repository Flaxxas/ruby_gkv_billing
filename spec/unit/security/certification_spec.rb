RSpec.describe RubyGkvBilling::Security::Certification do
  describe "creating key" do
    let(:key) { RubyGkvBilling::Security::Certification.create_key!("1234567", RubyGkvBilling.root)}
    let(:private_key) { File.join(RubyGkvBilling.root, "private_1234567_key.pem") }
    let(:public_key) { File.join(RubyGkvBilling.root, "public_1234567_key.pem") }

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
        RubyGkvBilling.root,
        "1234567",
        "OrgaName",
        "Ansprechpartner",
        key: key
        )
      }
      let(:private_key) { File.join(RubyGkvBilling.root, "spec/examples/private_1234567_key.pem") }
      let(:key) { RubyGkvBilling::Security::Certification.open_key(private_key) }
      let(:crt_path) { File.join(RubyGkvBilling.root, "1234567.p10") }

      before do
        crt
      end

      it {
        expect(crt.subject.to_s).to eq("/C=DE/O=ITSG TrustCenter fuer sonstige Leistungserbringer/OU=OrgaName/OU=IK1234567/CN=Ansprechpartner")
      }

      it {
        expect(crt.public_key.to_s).to eq(key.public_key.to_s)
      }
    end

    context "with new key" do
      let(:crt) { RubyGkvBilling::Security::Certification.create_certificate_request!(
        RubyGkvBilling.root,
        "1234567",
        "OrgaName",
        "Ansprechpartner"
        )
      }
      let(:private_key) { File.join(RubyGkvBilling.root, "private_1234567_key.pem") }
      let(:public_key) { File.join(RubyGkvBilling.root, "public_1234567_key.pem") }
      let(:crt_path) {
        File.join(RubyGkvBilling.root, "1234567.p10")
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
end