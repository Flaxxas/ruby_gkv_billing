RSpec.describe RubyGkvBilling::Provider do
  subject {RubyGkvBilling::Provider.new("AOK", "107415518", "34")}

  it { expect(subject.provider_message).not_to be_nil}
  it { expect(subject.data_receipient_message).not_to be_nil}

  it { expect(subject.provider_ik).to eq("107415518")}
  it { expect(subject.provider_short_name).to eq("AOK Südlicher Oberrhein")}
  it { expect(subject.provider_full_name).to eq("AOK Südlicher Oberrhein")}

  it { expect(subject.provider_contact_persons).to be_empty}

  it { expect(subject.provider_addresses.length).to eq(1)}
  it { expect(subject.provider_addresses.first[:code]).to eq("79098")}
  it { expect(subject.provider_addresses.first[:city]).to eq("Freiburg")}
  it { expect(subject.provider_addresses.first[:street]).to eq("Fahnenbergplatz 6")}

  it { expect(subject.data_receipient_ik).to eq("108018007")}
  it { expect(subject.data_receipient_short_name).to eq("ITSCare DAV")}
  it { expect(subject.data_receipient_full_name).to eq("IT-Services für den Gesundheitsmarkt")}

  it { expect(subject.data_receipient_addresses.length).to eq(1)}
  it { expect(subject.data_receipient_addresses.first[:code]).to eq("77933")}
  it { expect(subject.data_receipient_addresses.first[:city]).to eq("Lahr")}
  it { expect(subject.data_receipient_addresses.first[:street]).to eq("Schwarzwaldstr. 39")}

  it { expect(subject.data_receipient_contact_persons.length).to eq(1)}
  it { expect(subject.data_receipient_contact_persons.first[:phone]).to eq("07821/937108")}
  it { expect(subject.data_receipient_contact_persons.first[:fax]).to eq("07821/937229")}
  it { expect(subject.data_receipient_contact_persons.first[:name]).to eq("Frau Warten")}
  it { expect(subject.data_receipient_contact_persons.first[:working_area]).to eq("DTA § 302")}

  it { expect(subject.data_receipient_transmissions.length).to eq(3)}
  it { expect(subject.data_receipient_transmissions.first[:protocol]).to eq("E-Mail/Internet")}
  it { expect(subject.data_receipient_transmissions.first[:communication_channel]).to eq("da@dta.aok.de")}

  it { expect(subject.data_receipient_transmissions[1][:protocol]).to eq("011")}

  it { expect(subject.data_receipient_transmissions.last[:protocol]).to eq("FTAM")}
  it { expect(subject.data_receipient_transmissions.last[:communication_channel]).to eq("217.110.255.52?:5000")}
  it { expect(subject.data_receipient_transmissions.last[:user_id]).to be_empty}
  it { expect(subject.data_receipient_transmissions.last[:transmission_from]).to eq("00:00")}
  it { expect(subject.data_receipient_transmissions.last[:transmission_to]).to eq("24:00")}
  it { expect(subject.data_receipient_transmissions.last[:transmission_days]).to eq("Übertragung an allen Tagen")}

  context "invalid provider type", focus:true do
    it "no nullpointer exception" do
      provider = RubyGkvBilling::Provider.new("BKK_old", "103411401", "00")
      expect(provider.provider_full_name).to be_nil
      expect(provider.provider_ik).to be_nil
      expect(provider.provider_short_name).to be_nil
      expect(provider.provider_addresses).to be_empty
      expect(provider.provider_contact_persons).to be_empty

      expect(provider.data_receipient_full_name).to be_nil
      expect(provider.data_receipient_ik).to be_nil
      expect(provider.data_receipient_short_name).to be_nil
      expect(provider.data_receipient_addresses).to be_empty
      expect(provider.data_receipient_contact_persons).to be_empty
      expect(provider.data_receipient_transmissions).to be_empty
    end
  end

  context "Lookup for 2 messages" do
    it "has correct provider and data receipient" do
      # TODO: Ist das ein Spezialfall? Die erste gefundene Nachricht enthält sowohl Verweis auf Datenempfänger in einer anderen Nachricht, aber hat selber trotzdem DFÜ-Segmente..
      provider = RubyGkvBilling::Provider.new("AOK", "105998018", "21")
      expect(provider.provider_ik).to eq("105998018")
      expect(provider.provider_short_name).to eq("AOK Plus")
      expect(provider.provider_full_name).to eq("AOK Plus")
      expect(provider.data_receipient_ik).to eq("107299005")
      expect(provider.data_receipient_short_name).to eq("DAV AOK Plus Sachsen")
      expect(provider.data_receipient_transmissions.last[:communication_channel]).to eq("ftam.kubus-it.de?:5000")
    end
  end

  context "different data_receipients dependent on billing code" do

    it "Lookup for 2 messages, data receipient is DAVASO" do
      provider = RubyGkvBilling::Provider.new("AOK", "103411401", "21")
      expect(provider.provider_ik).to eq("103411401")
      expect(provider.provider_short_name).to eq("AOK NORDWEST")
      expect(provider.data_receipient_ik).to eq("661430035")
      expect(provider.data_receipient_short_name).to eq("DAVASO GmbH")
    end

    it "Lookup for 1 message, data receipient itself is AOK NORDWEST" do
      provider = RubyGkvBilling::Provider.new("AOK", "103411401", "11")
      expect(provider.provider_ik).to eq("103411401")
      expect(provider.provider_short_name).to eq("AOK NORDWEST")
      expect(provider.data_receipient_ik).to eq("103411401")
      expect(provider.data_receipient_short_name).to eq("AOK NORDWEST")
      expect(provider.data_receipient_transmissions.last[:communication_channel]).to eq("ftam.gkvi.de?:5000")
    end
  end

  context "Lookup for 3 messages: AOK in Erbach -> provider: AOK Hessen -> data receipient: ITSCare" do
    it "has correct provider and data receipient" do
      provider = RubyGkvBilling::Provider.new("AOK", "105213188", "21")
      expect(provider.provider_ik).to eq("105313145")
      expect(provider.provider_short_name).to eq("AOK Hessen")
      expect(provider.provider_full_name).to eq("AOK-Die Gesundheitskasse in Hessen")
      expect(provider.data_receipient_ik).to eq("105810615")
      expect(provider.data_receipient_short_name).to eq("ITSCare DAV")
    end
  end

  # it "verbose", focus:true do
  #   puts subject.provider_message.high_level_parse
  #   puts "****************"
  #   puts subject.data_receipient_message.high_level_parse
  # end
end
