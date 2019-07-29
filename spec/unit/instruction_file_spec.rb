RSpec.describe RubyGkvBilling::InstructionFile do
  subject{ RubyGkvBilling::InstructionFile.new(
    "1",
    "600300080",
    "absender_phys",
    "empf_nutzer",
    "empf_phys",
    "S",
    "T",
    "nutzdaten",
    "übertragung",
    "I1",
    "test@test.de",
    "datei_bezeichnung"
    ) }

  describe "contents" do
    it {
      expect(subject.content.size).to eq(348)
    }

    it {
      expect(subject.basic_fields).to include("600300080")
    }

    it {
      expect(subject.rz_fields).to include("datei_bezeichnung")
    }
  end

  it {
    expect(subject.instruction_filename).to eq("TSOL0001")
  }

  it {
    expect(subject.payload_filename).to eq("SL030008S07")
  }

  describe "file generation" do
    let(:path) { RubyGkvBilling.root }
    let(:file) { File.join(path, subject.instruction_filename) }
    before do
      subject.store(path)
    end

    it {
      expect(File.exists?(file)).to be_truthy
    }

    it {
      expect(file).to include("SOL")
    }

    after do
      File.delete(file) if File.exists?(file)
    end
  end

  describe "helper methods" do
    it {
      expect(subject.numeric(4, 4)).to eq("0004")
    }

    it {
      expect(subject.alpha(4, 4)).to eq("4   ")
    }

    it {
      expect(subject.alphanumeric(4, 4)).to eq("4   ")
    }
  end
end
