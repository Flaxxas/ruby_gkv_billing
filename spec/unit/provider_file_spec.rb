RSpec.describe RubyGkvBilling::ProviderFile do
  subject {RubyGkvBilling::ProviderFile.new("spec/examples/bkk.edifact")}

  let(:message){subject.search_by_ik("101391700")}
  let(:message2){subject.search_by_ik("101520147")}

  it { expect(message).not_to be_nil}
  it { expect(message.data_entry("Segment_Name", "Name-1")).not_to be_nil}
  it { expect(message.data_entry("Segment_Name", "Name-1")).to eq("NOVITAS BKK")}
  it { expect(message2.data_entry("Segment_Name", "Name-1")).to eq("Shell")}

  describe "search for dfu 3 Steps" do
    it { expect(subject.dfu_for_client("101520147", "40").length).to eq(2)}
    it { expect(subject.dfu_for_client("101520147", "40")[1]).to eq("ftam.arz-emmendingen.de?:9000")}
  end

  describe "search for dfu 2 Steps" do
    it { expect(subject.dfu_for_client("101538012", "71").length).to eq(1)}
    it { expect(subject.dfu_for_client("101538012", "71").first).to eq("dta302@ddg-online.de")}
  end

  describe "invalid data" do
    it { expect(subject.dfu_for_client("101538013", "71")).to be_nil}
    it { expect(subject.dfu_for_client("101538012", "99")).to be_nil}
  end

end
