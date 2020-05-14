RSpec.describe RubyGkvBilling::Security::KeyStore do
  subject { RubyGkvBilling::Security::KeyStore.new }

  it {
    expect(File.exist?(subject.certificate_file)).to be_truthy
  }

  it {
    expect(subject.certificates).not_to be_empty
  }

  it {
    expect(subject.certificates).not_to be_empty
  }

  describe "searching ik" do
    let(:crt) { subject.search_certificate("590105277") }

    it {
      expect(crt).not_to be_nil
    }

    it {
      expect(crt.subject.to_s).to include("ITSG")
    }

    it {
      expect(crt.subject.to_s).to include("Christian")
    }

    it {
      expect(crt.public_key).not_to be_nil
    }

    it {
      expect(subject.search_certificate("2345")).to be_nil
    }

    context "Rentenversicherung" do
      let(:rente) { subject.search_certificate("110999007") }

      it {
        expect(rente).not_to be_nil
      }

      it {
        expect(rente.subject.to_s).to include("Rentenversicherung")
      }

      it {
        expect(rente.public_key).not_to be_nil
      }
    end
  end

  describe "re-downloading file" do
    before do
      File.delete(subject.certificate_file)

      subject.download_new_certificates
      subject.import_certificates
    end

    it {
      expect(File.exist?(subject.certificate_file)).to be_truthy
    }

    it {
      expect(subject.certificates).not_to be_empty
    }
  end
end
