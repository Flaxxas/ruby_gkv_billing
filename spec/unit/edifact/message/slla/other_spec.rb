RSpec.describe RubyGkvBilling::Edifact::Message::Slla::Other do
  subject { RubyGkvBilling::Edifact::Message::Slla::Other.new(
    "123",
    #FKT_SEGMENT
    "01",
    "IK5430684",
    "IK8234568",
    "IK8643456",
    "IK5924783",
    #REC_SEGMENT
    "rechungsnummer",
    "sammel_nummer",
    "001",
    "0",
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
    "merkmal"
  ) }

  it { expect(subject.fkt_segment.to_edifact).to eq(
    "FKT+01+IK5430684+IK8234568+IK8643456+IK5924783'"
  ) }

  it { expect(subject.rec_segment.to_edifact).to eq(
    "REC+rechungsnummer+sammel_nummer+001+#{Time.now.strftime("%Y%m%e")}+0'"
  ) }

  it { expect(subject.inv_segment.to_edifact).to eq(
    "INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'"
  ) }

  it { expect(subject.uri_segment.to_edifact).to eq(
    "URI+zuzhalung'"
  ) }

  it { expect(subject.nad_segment.to_edifact).to eq(
    "NAD+vers_nachname+vers_vorname+vers_gebdatum+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'"
  ) }

  it { expect(subject.img_segment.to_edifact).to eq(
    "IMG+2019+07+merkmal'"
  ) }

  it { expect(subject.to_edifact).to include(
    "UNH+00123+SLLA:12:0:0'",
    "FKT+01+IK5430684+IK8234568+IK8643456+IK5924783'",
    "REC+rechungsnummer+sammel_nummer+001+#{Time.now.strftime("%Y%m%e")}+0'",
    "INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'",
    "URI+zuzhalung'",
    "NAD+vers_nachname+vers_vorname+vers_gebdatum+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'",
    "IMG+2019+07+merkmal'",
    "UNT+8+00123'"
  ) }

end
