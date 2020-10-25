RSpec.describe RubyGkvBilling::Edifact::Message::Slla::Medicine do
  subject { RubyGkvBilling::Edifact::Message::Slla::Medicine.new(
    #INV_SEGMENT
    "versicherten_nr",
    "18",
    "0",
    "beleg_nr",
    "besondere_versorgung",
    #URI_SEGMENT
    "123456789",
    "sammel",
    "einzel",
    Date.civil(2020,1,1),
    "belegnum",
    #NAD_SEGMENT
    "vers_nachname",
    "vers_vorname",
    Date.new(2010, 10, 9),
    "vers_strasse",
    "vers_plz",
    "vers_ort",
    "vers_kennzeichen",
    #IMG_SEGMENT
    Time.new(2010,10,10).strftime("%Y"),
    Time.new(2010,10,10).strftime("%m"),
    "merkmal",
    #ZHE_SEGMENT
    "1",
    "11",
    "1",
    "1",
    "1",
    "1",
    "1",
    #BES_SEGMENT
    "123,47",
    "432.39",
    "65,39",
    "345.21",
    #GZF_SEGMENT
    "567,432",
    "43",
    "765,45679",
    #OPTIONAL ZHE_SEGMENT
    behandlungsbeginn: Time.new(2010,10,10),
    verordnungs_datum: Time.new(2011,11,11),
    #OPTIONAL SKZ_SEGMENT
    genehmigungskennzeichen: "4567643",
    genehmigungsart: "01",
    datum_genehmigung: Time.new(2012,12,12)
    ) }

  before do
    subject.add_ehe_segment(
      #EHE_SEGMENT
      "01",
      "35632",
      "test",
      "43,12",
      "34565,32",
      "63445",
      "234",
      #TXT_SEGMENT
      text: "text",
      #MWS_SEGMENT
      kennzeichen_mws: "1",
      betrag_mws: "23454",
      datum_leistungserbringung: Time.new(2010,10,10)
    )
    subject.add_diagnose(
      "1234567",
      "diganose_text"
    )
  end

  describe "add_ehe_segments" do
    it { expect(subject.ehe_segment(
      "01",
      "35632",
      "test",
      "43",
      "34565",
      Time.new(2010,10,10),
      "63445",
      "234"
    ).to_edifact).to eq("EHE+01:35632+test+43,00+34565,00+20101010+63445,00+234'") }

    it { expect(subject.txt_segment("text").to_edifact).to eq("TXT+text'") }

    it { expect(subject.mws_segment("1", "23454").to_edifact).to eq("MWS+1+23454,00'") }
  end

  it { expect(subject.zhe_segment.to_edifact).to eq("ZHE+999999999+999999999+20111111+1+9999+11+1+1+1+20101010+1+1'") }

  it { expect(subject.skz_segment.to_edifact).to eq("SKZ+4567643+20121212+01'") }

  it { expect(subject.bes_segment.to_edifact).to eq("BES+123,47+432,39+65,39+345,21'") }

  it { expect(subject.gzf_segment.to_edifact).to eq("GZF+567,43+43,00+765,46'") }

  it { expect(subject.inv_segment.to_edifact).to eq("INV+versicherten_nr+18000+0+beleg_nr+besondere_versorgung'") }

  it { expect(subject.uri_segment.to_edifact).to eq("URI+123456789+sammel:einzel+20200101+belegnum'") }

  it { expect(subject.nad_segment.to_edifact).to eq("NAD+vers_nachname+vers_vorname+20101009+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'") }

  it { expect(subject.img_segment.to_edifact).to eq("IMG+2010+10+merkmal'") }

  it { expect(subject.segments.count).to eq(11) }

  describe "in sequence" do
    it { expect(subject.segments[0].to_edifact).to eq("INV+versicherten_nr+18000+0+beleg_nr+besondere_versorgung'") }
    it { expect(subject.segments[1].to_edifact).to eq("URI+123456789+sammel:einzel+20200101+belegnum'") }
    it { expect(subject.segments[2].to_edifact).to eq("NAD+vers_nachname+vers_vorname+20101009+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'") }
    it { expect(subject.segments[3].to_edifact).to eq("IMG+2010+10+merkmal'") }
    it { expect(subject.segments[4].to_edifact).to eq("EHE+01:35632+test+43,12+34565,32+20101010+63445,00+234'") }
    it { expect(subject.segments[5].to_edifact).to eq("TXT+text'") }
    it { expect(subject.segments[6].to_edifact).to eq("MWS+1+23454,00'") }
    it { expect(subject.segments[7].to_edifact).to eq("ZHE+999999999+999999999+20111111+1+9999+11+1+1+1+20101010+1+1'") }
    it { expect(subject.segments[8].to_edifact).to eq("DIA+1234567+diganose_text'") }
    it { expect(subject.segments[9].to_edifact).to eq("SKZ+4567643+20121212+01'") }
    it { expect(subject.segments[10].to_edifact).to eq("GZF+567,43+43,00+765,46'") }
  end

end
