RSpec.describe RubyGkvBilling::Edifact::Segment do
  subject { RubyGkvBilling::Edifact::Segment.new("UNB", initial_elements: ["Test 123"])}

  before do
    subject.<<(-3.14)
    subject.<<("D'Angelo")
    subject.<<("Test?")
    subject.add_splitted_element(["Version 3", "0", "0"])
  end

  it {
    expect(subject.elements[0]).to eq("UNB")
  }

  it {
    expect(subject.elements.size).to eq(6)
  }

  it {
    expect(subject.to_edifact).to eq("UNB+Test 123+-3,14+D?'Angelo+Test??+Version 3:0:0'")
  }

  describe "floats" do
    it { expect(subject.convert_float(4)).to include("4,00") }
    it { expect(subject.convert_float(4.2324)).to include("4,23") }
    it { expect(subject.convert_float("4.2384")).to include("4,24") }
    it { expect(subject.convert_float("4,2384")).to include("4,24") }
  end
end
