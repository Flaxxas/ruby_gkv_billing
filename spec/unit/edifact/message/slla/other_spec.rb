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
  end

  it { expect(subject.dia_segment("01", "Test").to_edifact).to eq("DIA+01+Test'") }

  it { expect(subject.zuv_segment.to_edifact).to eq("ZUV+999999999+999999999+20190730+1+1+1+1'") }

  it { expect(subject.skz_segment.to_edifact).to eq("SKZ+01+20190730+02'") }

  it { expect(subject.bes_segment.to_edifact).to eq("BES+1234+765+45+7854+456'") }

  it { expect(subject.inv_segment.to_edifact).to eq("INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'") }

  it { expect(subject.uri_segment.to_edifact).to eq("URI+zuzhalung'") }

  it { expect(subject.nad_segment.to_edifact).to eq("NAD+vers_nachname+vers_vorname+vers_gebdatum+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'") }

  it { expect(subject.img_segment.to_edifact).to eq("IMG+2019+07+merkmal'") }

  it { expect(subject.segments.count).to eq(8) }


end
