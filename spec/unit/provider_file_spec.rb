RSpec.describe RubyGkvBilling::ProviderFile do
  subject {RubyGkvBilling::ProviderFile.new("BKK")}

  let(:message){subject.search_by_ik("101391700")}
  let(:message2){subject.search_by_ik("101520147")}

  it { expect(RubyGkvBilling::ProviderFile.billing_category("14")).to eq("Hörgeräteakustiker")}

  it {expect(subject.dataname).to eq("BK05Q419ke0")}

  it { expect(message).not_to be_nil}
  it { expect(message.data_entry("Segment_Name", "Name-1")).not_to be_nil}
  it { expect(message.data_entry("Segment_Name", "Name-1")).to eq("NOVITAS BKK")}
  it { expect(message2.data_entry("Segment_Name", "Name-1")).to eq("Shell")}

  describe "search for dfu 3 Steps" do
    it { expect(subject.dfu_for_client("101520147", "43").length).to eq(2)}
    it { expect(subject.dfu_for_client("101520147", "43")[1]).to eq("ftam.arz-emmendingen.de?:9000")}
  end

  describe "search for dfu 2 Steps" do
    it { expect(subject.dfu_for_client("101538012", "71").length).to eq(1)}
    it { expect(subject.dfu_for_client("101538012", "71").first).to eq("dta302@ddg-online.de")}
  end

  describe "invalid data" do
    it { expect(subject.dfu_for_client("101538013", "71")).to be_nil}
    it { expect(subject.dfu_for_client("101538012", "99")).to be_nil}
  end

  context "AOK Südlicher Oberrhein" do
    subject {RubyGkvBilling::ProviderFile.new("AOK")}

    it {expect(subject.dataname).to eq("AO05Q319ke1")}

    it { expect(subject.dfu_for_client("107415518", "00").length).to eq(3)}
    it { expect(subject.dfu_for_client("107415518", "00").last).to eq("217.110.255.52?:5000")}
    it { expect(subject.dfu_for_client("107415518", "34").last).to eq("217.110.255.52?:5000")}

    it { expect(subject.dfu_for_client("107415518", "34", all_segments: true).first).to be_a(Hash)}
    it { expect(subject.dfu_for_client("107415518", "34", all_segments: true).first.length).to eq(8)}
  end

end
