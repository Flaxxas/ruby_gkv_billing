RSpec.describe RubyGkvBilling::Reha301::Xml::SchemaValidator do
  let(:file) {  File.join(RubyGkvBilling.root, 'docs/Reha301/examples/GKV_XML_Absage_durch_Kostentraeger_ABK_V340_20191015.xml') }
  let(:xml) { File.read(file) }
  subject { RubyGkvBilling::Reha301::Xml::SchemaValidator.new(xml) }

  describe "invalid document" do

    it {
      expect(subject.errros).not_to be_empty
    }

    it {
      expect(subject).not_to be_valid
    }

    it {
      expect(subject.schema_file).to include("4.2.0")
    }
  end

  describe "valid document" do
    let(:file) {  File.join(RubyGkvBilling.root, 'spec/examples/reha301/phasenwechsel_antwort.xml') }

    it {
      expect(subject.errros).to be_empty
    }

    it {
      expect(subject).to be_valid
    }
  end
end
