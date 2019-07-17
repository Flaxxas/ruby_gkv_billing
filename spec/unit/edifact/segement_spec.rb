RSpec.describe RubyGkvBilling::Edifact::Segment do
  subject { RubyGkvBilling::Edifact::Segment.new("UNB", initial_elements: ["Test 123"])}

  before do
    subject.<<(-3.14)
    subject.<<("D'Angelo")
    subject.<<("Test?")
  end

  it {
    expect(subject.elements[0]).to eq("UNB")
  }

  it {
    expect(subject.elements.size).to eq(5)
  }

  it {
    expect(subject.to_edifact).to eq("UNB+Test:123+-3,14+D?'Angelo+Test??'")
  }
end
