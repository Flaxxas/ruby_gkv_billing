RSpec.describe RubyGkvBilling::InstructionFile do
  subject{ RubyGkvBilling::InstructionFile.new(
    "1",
    "absender_eigner",
    "absender_phys",
    "empf_nutzer",
    "empf_phys",
    "typ",
    "T",
    "nutzdaten",
    "übertragung",
    "I1",
    "test@test.de",
    "datei_bezeichnung"
    ) }


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
end
