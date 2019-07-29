RSpec.describe RubyGkvBilling::Edifact do
  describe "physical_filename" do
    subject{ RubyGkvBilling::Edifact.physical_filename("E", "2", leistung_erbringer_gruppe: "SOL", version: "0") }

    it { expect(subject).to eq("ESOL0002") }
    it { expect(subject.size).to eq(8) }
  end

  describe "physical_filename" do
    subject{ RubyGkvBilling::Edifact.logical_filename("IKDE4321", "S", 2, classification: "SL") }

    it { expect(subject).to eq("SLDE4321S02") }
    it { expect(subject.size).to eq(11) }
  end
end
