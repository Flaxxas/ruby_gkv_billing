RSpec.describe RubyGkvBilling::Reha301::Xml::BaseDocument do
  subject { RubyGkvBilling::Reha301::Xml::BaseDocument.new(21, papieranlage: true, freitext: "XYZ", drv: true) }

  it {
    expect(subject.to_xml).to include("<reh:Nachrichtentyp>21</reh:Nachrichtentyp>")
  }

  it {
    expect(subject.to_xml).to include("<reh:Freier_Text>XYZ</reh:Freier_Text>")
  }

  it {
    expect(subject.to_xml).to include("<reh:Papieranlage>J</reh:Papieranlage>")
  }

  it {
    expect(subject.papieranlage).to eq("J")
  }

  it {
    expect(subject.rv_type).to eq("RV")
  }

  describe 'kopfdaten' do
    let(:xml) {
      Nokogiri::XML::Builder.new(encoding: RubyGkvBilling::Reha301::Xml::ENCODING) do |xml|
        xml.send("reh:Reha", RubyGkvBilling::Reha301::Xml.base_attributes) {
          subject.kopfdaten_head(xml,
            "123",
            "IKabs",
            "IKem",
            "IKKos",
            "IKbeauf",
            "ikein",
            "fachab",
            erstellungsdatum: Time.new(2020,2,1,10,12,22,33)
          )
        }
      end
    }

    let(:xml_doc) {
      xml.to_xml
    }

    it {
      expect(xml_doc).to include("<kod:Erstellungsdatum_Uhrzeit>2020-02-01T10:12:22</kod:Erstellungsdatum_Uhrzeit>")
    }

    it {
      expect(xml_doc).to include("<kod:Dateinummer>123</kod:Dateinummer>")
    }

    it {
      expect(xml_doc).to include("<kod:Identifikationsdaten>")
    }

    it {
      expect(xml_doc).to include("<kod:Fachabteilung>fachab</kod:Fachabteilung>")
    }
  end
end
