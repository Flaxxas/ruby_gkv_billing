RSpec.describe RubyGkvBilling::Edifact::Message::Slga do
  subject { RubyGkvBilling::Edifact::Message::Slga.new(
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
    #NAM_SEGMENT
    "Firma",
    "E-Mail",
    nachrichten_ref_nummer: "123",
    #OPTIONAL => FKT_SEGMENT
    sammelrechnung: "N",
    #OPTIONAL => UST_SEGMENT
    steuernummer: "steuernummer",
    ust_befreiung: "J",
    #OPTIONAL => SKO_SEGMENT
    skonto_prozent: "0",
    zahlungsziel: "5",
    #OPTIONAL => NAM_SEGMENT
    name2: "partner tel",
    datum: Time.new(2010,10,9)
  ) }

  let(:ges_segment) {
    subject.ges_segment(
      "00",
      "435,20",
      "23.756",
      234.214
    )
  }

  before do
    subject.<< ges_segment
    subject.<< subject.nam_segment
  end

  it { expect(subject.fkt_segment.to_edifact).to eq(
    "FKT+01+N+IK5430684+IK8234568+IK8643456+IK5924783'"
  ) }

  it { expect(subject.rec_segment.to_edifact).to eq(
    "REC+sammel_nummer:001+20101009+0'"
  ) }

  it { expect(subject.ust_segment.to_edifact).to eq(
    "UST+steuernummer+J'"
  ) }

  it { expect(subject.sko_segment.to_edifact).to eq(
    "SKO+0+5'"
  ) }

  it { expect(ges_segment.to_edifact).to eq(
    "GES+00+435,20+23,76+234,21'"
  ) }

  it { expect(subject.nam_segment.to_edifact).to eq(
    "NAM+Firma+partner tel+E-Mail'"
  ) }

  it { expect(subject.to_edifact).to eq(
    ["UNH+00123+SLGA:13:0:0'",
    "FKT+01+N+IK5430684+IK8234568+IK8643456+IK5924783'",
    "REC+sammel_nummer:001+20101009+0'",
    "UST+steuernummer+J'",
    "SKO+0+5'",
    "GES+00+435,20+23,76+234,21'",
    "NAM+Firma+partner tel+E-Mail'",
    "UNT+8+00123'"].join("\n")
  ) }


end
