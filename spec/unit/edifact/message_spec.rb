RSpec.describe RubyGkvBilling::Edifact::Message do
  subject { RubyGkvBilling::Edifact::Message.new(123, "SLGA") }

  let(:segment) { RubyGkvBilling::Edifact::Segment.new("UNB", initial_elements: ["Test 123"]) }

  before do
    segment.<<(-3.14)
    segment.<<("D'Angelo")
    segment.<<("Test?")

    subject.<< segment
  end

  it {
    expect(subject.header_segment.to_edifact).to eq("UNH+00123+SLGA:18:0:0'")
  }

  it {
    expect(subject.footer_segment.to_edifact).to eq("UNT+000003+00123'")
  }

  it {
    expect(subject.to_edifact).to eq(["UNH+00123+SLGA:18:0:0'",
                                      "UNB+Test 123+-3,14+D?'Angelo+Test??'",
                                      "UNT+000003+00123'"].join("\n"))
  }
end
