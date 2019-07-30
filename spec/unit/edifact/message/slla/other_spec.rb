RSpec.describe RubyGkvBilling::Edifact::Message::Slla::Other do
  subject { RubyGkvBilling::Edifact::Message::Slla::Other.new(
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
    Time.now.strftime("%Y"),
    Time.now.strftime("%m"),
    "merkmal",
    #BES_SEGMENT
    "1234",
    "765",
    "45",
    "7854",
    "456",
    #OPTIONAL ZUV_SEGMENT
    zuzahlungskennzeichen: "1",
    unfallkennzeichen: "1",
    kennzeichen_bvg: "1",
    kennzeichen_verordnungsbesonderheiten: "1",
    verordnungs_datum: Time.now,
    #OPTIONAL SKZ_SEGMENT
    genehmigungskennzeichen: "01",
    genehmigungsart: "02",
    datum_genehmigung: Time.now
    ) }

  before do
    subject.add_diagnose("01", "Test")
    subject.add_enf_segment(
      #ENF_SEGMENT
      "123",
      "01",
      "35632",
      "test",
      "43",
      "34565",
      "63445",
      #SUT_SEGMENT
      "234",
      "45",
      #TXT_SEGMENT
      "text",
      #MWS_SEGMENT
      "1",
      "23454"
    )
  end

  describe "add_enf_segment" do
    it { expect(subject.enf_segment(
      "123",
      "01",
      "35632",
      "test",
      "43",
      "34565",
      Time.new(2010,10,10),
      "63445").to_edifact).to eq("ENF+123+01:35632+test+43+34565+20101010+63445'") }

    it { expect(subject.sut_segment(
      "234",
      Time.new(2010,10,10),
      Time.new(2011,11,11),
      "45",
      Time.new(2010,10,10),
      Time.new(2011,11,11)).to_edifact).to eq("SUT+234+0000+0000+45+20101010+20111111'") }

    it { expect(subject.txt_segment("text").to_edifact).to eq("TXT+text'") }

    it { expect(subject.mws_segment("1", "23454").to_edifact).to eq("MWS+1+23454'") }
  end

  it { expect(subject.dia_segment("01", "Test").to_edifact).to eq("DIA+01+Test'") }

  it { expect(subject.zuv_segment.to_edifact).to eq("ZUV+999999999+999999999+20190730+1+1+1+1'") }

  it { expect(subject.skz_segment.to_edifact).to eq("SKZ+01+20190730+02'") }

  it { expect(subject.bes_segment.to_edifact).to eq("BES+1234+765+45+7854+456'") }

  it { expect(subject.inv_segment.to_edifact).to eq("INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'") }

  it { expect(subject.uri_segment.to_edifact).to eq("URI+zuzhalung'") }

  it { expect(subject.nad_segment.to_edifact).to eq("NAD+vers_nachname+vers_vorname+vers_gebdatum+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'") }

  it { expect(subject.img_segment.to_edifact).to eq("IMG+2019+07+merkmal'") }

  it { expect(subject.segments.count).to eq(12) }


end
