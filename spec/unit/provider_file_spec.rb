RSpec.describe RubyGkvBilling::ProviderFile do
  subject {RubyGkvBilling::ProviderFile.new("BKK_2020_Q3_Nachtrag1")}

  let(:message){subject.search_by_ik("101391700")}
  # NOTE: In neuer Datei nicht vorhanden..
  # let(:message2){subject.search_by_ik("101520147")}

  it { expect(RubyGkvBilling::ProviderFile.billing_category("14")).to eq("14 - Hörgeräteakustiker")}

  it {expect(subject.dataname).to eq("BK05Q320ke1")}

  it { expect(message).not_to be_nil}
  it { expect(message.data_entry("Segment_Name", "Name-1")).not_to be_nil}
  it { expect(message.data_entry("Segment_Name", "Name-1")).to eq("NOVITAS BKK")}
  # it { expect(message2.data_entry("Segment_Name", "Name-1")).to eq("Shell")}

  describe "search for dfu 2 Steps" do
    skip "Provider does not exist anymore?" do
      it { expect(subject.provider_message("101520147")).not_to be_nil}

      it "has data_recipient_message" do
        pm = subject.provider_message("101520147")
        expect(subject.data_recipient_message(pm, "71")).not_to be_nil
      end

      it { expect(subject.contact_messages("101520147", "71").length).to eq(2)}
      it { expect(subject.contact_messages("101520147", "71")[:provider_message].data_entry("Segment_Identifikation", "Institutionskennzeichen")).to eq("105830016")}
      it { expect(subject.contact_messages("101520147", "71")[:data_recipient_message].data_entry("Segment_Identifikation", "Institutionskennzeichen")).to eq("661430046")}
      it { expect(subject.contact_messages("101520147", "71")[:data_recipient_message].data_entry("Segment_DFÜ", "Kommunikationskanal").length).to eq(2)}
      it { expect(subject.contact_messages("101520147", "71")[:data_recipient_message].data_entry("Segment_DFÜ", "Kommunikationskanal").last).to eq("ftam.syntela.de?:9000")}
    end
  end

  describe "invalid data" do
    it { expect(subject.contact_messages("101538013", "71")).to be_empty}
    it { expect(subject.contact_messages("101538999", "00")).to be_empty}
  end

  context "AOK Südlicher Oberrhein" do
    subject {RubyGkvBilling::ProviderFile.new("AOK_2020_Q3_Standard")}

    it {expect(subject.dataname).to eq("AO05Q320ke0")}

    it { expect(subject.contact_messages("107415518", "00").length).to eq(2)}
    it { expect(subject.contact_messages("107415518", "00")[:provider_message].data_entry("Segment_Name", "Name-1")).to eq("AOK Südlicher Oberrhein")}
    it { expect(subject.contact_messages("107415518", "00")[:data_recipient_message].data_entry("Segment_DFÜ", "Kommunikationskanal").length).to eq(2)}
    it { expect(subject.contact_messages("107415518", "00")[:data_recipient_message].data_entry("Segment_DFÜ", "Kommunikationskanal").last).to eq("217.110.255.52?:5000")}
    it { expect(subject.contact_messages("107415518", "34")[:data_recipient_message].data_entry("Segment_DFÜ", "Kommunikationskanal").last).to eq("217.110.255.52?:5000")}

    it { expect(subject.contact_messages("107415518", "34")[:data_recipient_message].data_entry("Segment_DFÜ").first).to be_a(Hash)}
    it { expect(subject.contact_messages("107415518", "34")[:data_recipient_message].data_entry("Segment_DFÜ").first.length).to eq(8)}

    # it "verbose one message", focus:true do
    #   puts "**************"
    #   puts subject.contact_messages("107415518", "34")[:data_recipient_message].high_level_parse
    #   puts "**************"
    #   puts subject.contact_messages("107415518", "34")[:data_recipient_message].high_level_parse
    #   puts "**************"
    # end
    #
    # it "verbose all messages", focus:true do
    #   subject.messages.each do |m|
    #     puts "**************"
    #     puts m.high_level_parse
    #   end
    # end
  end

  # TODO: Sonderfall?
  context "AOK NORDWEST" do
    subject {RubyGkvBilling::ProviderFile.new("AOK_2020_Q3_Standard")}

    it { expect(subject.provider_message("103511264")).not_to be_nil}

    it "has data_recipient_message" do
      pm = subject.provider_message("103511264")
      expect(subject.data_recipient_message(pm, "00")).not_to be_nil
    end

    it { expect(subject.contact_messages("103511264", "00").length).to eq(2)}
    it { expect(subject.contact_messages("103511264", "00")[:provider_message].data_entry("Segment_Identifikation", "Institutionskennzeichen")).to eq("103511264")}
    it { expect(subject.contact_messages("103511264", "00")[:data_recipient_message].data_entry("Segment_Identifikation", "Institutionskennzeichen")).to eq("103511264")}
    it { expect(subject.contact_messages("103511264", "34")[:data_recipient_message].data_entry("Segment_DFÜ", "Kommunikationskanal").first).to eq("da@dta.aok.de")}
  end
end
