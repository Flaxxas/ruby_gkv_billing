RSpec.describe RubyGkvBilling::Edifact::Message::Slla::Medicine do
  subject { RubyGkvBilling::Edifact::Message::Slla::Medicine.new(
    #INV_SEGMENT
    "versicherten_nr",
    "18",
    "0",
    "beleg_nr",
    "besondere_versorgung",
    #URI_SEGMENT
    "zuzhalung",
    #NAD_SEGMENT
    "vers_nachname",
    "vers_vorname",
    "vers_gebdatum",
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
    "123",
    "432",
    "65",
    "345",
    #GZF_SEGMENT
    "567",
    "43",
    "765",
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
      "43",
      "34565",
      "63445",
      "234",
      #TXT_SEGMENT
      text: "text",
      #MWS_SEGMENT
      kennzeichen_mws: "1",
      betrag_mws: "23454"
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
    ).to_edifact).to eq("EHE+01+35632+test+43+34565+20101010+63445+234'") }

    it { expect(subject.txt_segment("text").to_edifact).to eq("TXT+text'") }

    it { expect(subject.mws_segment("1", "23454").to_edifact).to eq("MWS+1+23454'") }
  end

  it { expect(subject.zhe_segment.to_edifact).to eq("ZHE+999999999+999999999+20111111+1+9999+11+1+1+1+20101010+1+1'") }

  it { expect(subject.skz_segment.to_edifact).to eq("SKZ+4567643+20121212+01'") }

  it { expect(subject.bes_segment.to_edifact).to eq("BES+123+432+65+345'") }

  it { expect(subject.gzf_segment.to_edifact).to eq("GZF+567+43+765'") }

  it { expect(subject.inv_segment.to_edifact).to eq("INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'") }

  it { expect(subject.uri_segment.to_edifact).to eq("URI+zuzhalung'") }

  it { expect(subject.nad_segment.to_edifact).to eq("NAD+vers_nachname+vers_vorname+vers_gebdatum+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'") }

  it { expect(subject.img_segment.to_edifact).to eq("IMG+2010+10+merkmal'") }

  it { expect(subject.segments.count).to eq(11) }

end
