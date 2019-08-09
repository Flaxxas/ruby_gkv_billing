RSpec.describe RubyGkvBilling::Edifact::Payload do
  subject { RubyGkvBilling::Edifact::Payload.new(
    "sender_file",
    "sender_description",
    "receiver_file",
    "receiver_description",
    "123",
    "service_area",
    "456",
    erstellt_am: Time.new(2010,10,10,12,12),
    testindikator: RubyGkvBilling::Edifact::Payload::TEST
  ) }

  let(:message) { RubyGkvBilling::Edifact::Message.new(123, "SLGA") }

  let(:segment) { RubyGkvBilling::Edifact::Segment.new("UNB", initial_elements: ["Test 123"]) }

  before do
    segment.<<(-3.14)
    segment.<<("D'Angelo")
    segment.<<("Test?")

    message.<< segment

    subject.<< message
  end

  it {
    expect(subject.header_segment.to_edifact).to eq("UNB+UNOC:3+sender_file+sender_description+receiver_file+receiver_description+20101010:1212+00123+service_area+00456+0'")
  }

  it {
    expect(subject.footer_segment.to_edifact).to eq("UNZ+1+00123'")
  }

  it {
    expect(subject.to_edifact).to include("UNB+UNOC:3+sender_file+sender_description+receiver_file+receiver_description+20101010:1212+00123+service_area+00456+0'",
                                          "UNH+00001+SLGA:12:0:0'",
                                          "UNB+Test 123+-3,14+D?'Angelo+Test??'",
                                          "UNT+3+00001'",
                                          "UNZ+1+00123'")
  }
end
