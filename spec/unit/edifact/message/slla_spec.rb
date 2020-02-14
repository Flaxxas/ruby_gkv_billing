RSpec.describe RubyGkvBilling::Edifact::Message::Slla do
  subject { RubyGkvBilling::Edifact::Message::Slla.new(
    #FKT_SEGMENT
    "01",
    "IK5430684",
    "IK8234568",
    "IK8643456",
    "IK5924783",
    #REC_SEGMENT
    "sammel_nummer",
    "001",
    "0",
    nachrichten_ref_nummer: "123",
    datum: Time.new(2010,10,10)
  ) }

  before do
    subject.add_inv_segment(
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
        "01012010",
        "belegnum",
        "10",
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
        "merkmal"
      )
  end

  it { expect(subject.fkt_segment.to_edifact).to eq(
    "FKT+01+IK5430684+IK8234568+IK8643456+IK5924783'"
  ) }

  it { expect(subject.rec_segment.to_edifact).to eq(
    "REC+sammel_nummer:001+20101010+0'"
  ) }

  it { expect(subject.to_edifact).to include(
    "UNH+00123+SLLA:12:0:0'",
    "FKT+01+IK5430684+IK8234568+IK8643456+IK5924783'",
    "REC+sammel_nummer:001+20101010+0'",
    "INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'",
    "NAD+vers_nachname+vers_vorname+vers_gebdatum+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'",
    "IMG+2010+10+merkmal'",
    "UNT+7+00123'"
  ) }

end
