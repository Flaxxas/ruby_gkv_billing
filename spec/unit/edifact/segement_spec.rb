RSpec.describe RubyGkvBilling::Edifact::Segment do
  subject { RubyGkvBilling::Edifact::Segment.new("UNB", initial_elements: ["Test 123"])}

  before do
    subject << -3.14
    subject << "D'Angelo"
  end

  it {
    expect(subject.elements[0]).to eq("UNB")
  }

  it {
    expect(subject.elements.size).to eq(4)
  }
end
