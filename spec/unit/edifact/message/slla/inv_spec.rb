RSpec.describe RubyGkvBilling::Edifact::Message::Slla::Inv do
  subject { RubyGkvBilling::Edifact::Message::Slla::Inv.new(
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
    Date.new(2010,10,10),
    "belegnum",
    #NAD_SEGMENT
    "vers_nachname",
    "vers_vorname",
    Date.new(2010,10,9),
    "vers_strasse",
    "vers_plz",
    "vers_ort",
    "vers_kennzeichen",
    #IMG_SEGMENT
    Time.new(2010,10,10).strftime("%Y"),
    Time.new(2010,10,10).strftime("%m"),
    "merkmal"
    ) }

  it { expect(subject.inv_segment.to_edifact).to eq("INV+versicherten_nr+00018+0+beleg_nr+besondere_versorgung'") }

  it { expect(subject.uri_segment.to_edifact).to eq("URI+123456789+sammel:einzel+20101010+belegnum'") }

  it { expect(subject.nad_segment.to_edifact).to eq("NAD+vers_nachname+vers_vorname+20101009+vers_strasse+vers_plz+vers_ort+vers_kennzeichen'") }

  it { expect(subject.img_segment.to_edifact).to eq("IMG+2010+10+merkmal'") }

  it { expect(subject.segments.count).to eq(4) }

  context "optional img and uri segment" do
    subject { RubyGkvBilling::Edifact::Message::Slla::Inv.new(
      #INV_SEGMENT
      "versicherten_nr",
      "18",
      "0",
      "beleg_nr",
      "besondere_versorgung",
      #URI_SEGMENT
      nil,
      nil,
      nil,
      nil,
      nil,
      #NAD_SEGMENT
      "vers_nachname",
      "vers_vorname",
      Date.new(2010,10,9),
      "vers_strasse",
      "vers_plz",
      "vers_ort",
      "vers_kennzeichen",
      #IMG_SEGMENT
      nil,
      nil,
      nil
      ) }

      it { expect(subject.segments.count).to eq(2) }
  end
end
