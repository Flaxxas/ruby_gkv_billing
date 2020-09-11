RSpec.describe RubyGkvBilling::Reha301::Xml::Attachment do
  let(:file) {  File.join(RubyGkvBilling.root, 'spec/examples/private_1234567_key.pem') }
  let(:xml) { Nokogiri::XML::Builder.new(encoding: RubyGkvBilling::Reha301::Xml::ENCODING) }
  subject { RubyGkvBilling::Reha301::Xml::Attachment.new(file) }

  it {
    expect(subject.filename_value).to eq("private_1234567_key.pem")
  }

  it {
    expect(subject.dateiart_value).to eq("PEM")
  }

  it {
    expect(subject.medical_value).to eq("N")
  }

  describe 'xml' do
    let(:xml) {
      Nokogiri::XML::Builder.new(encoding: RubyGkvBilling::Reha301::Xml::ENCODING) do |xml|
        xml.send("reh:Reha", RubyGkvBilling::Reha301::Xml.base_attributes) {
          subject.to_xml(xml)
        }
      end
    }

    let(:xml_doc) {
      xml.to_xml
    }

    it {
      expect(xml_doc).to include("<bty:medizinischesDokument>N</bty:medizinischesDokument>")
    }

    it {
      expect(xml_doc).to include("<bty:Dateiart>PEM</bty:Dateiart>")
    }

    it {
      expect(xml_doc).to include("<bty:Dateigroesse>3247</bty:Dateigroesse>")
    }
  end
end
