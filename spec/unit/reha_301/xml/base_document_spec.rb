RSpec.describe RubyGkvBilling::Reha301::Xml::BaseDocument do
  subject { RubyGkvBilling::Reha301::Xml::BaseDocument.new(21, papieranlage: true, freitext: "XYZ") }

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
end
