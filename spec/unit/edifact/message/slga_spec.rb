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
    #GES_SEGMENT
    "00",
    "gesbetrag",
    "brubetrag",
    "zubetrag",
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
    name2: "partner tel"
  ) }

  it { expect(subject.fkt_segment.to_edifact).to eq(
    "FKT+01+N+IK5430684+IK8234568+IK8643456+IK5924783'"
  ) }

  it { expect(subject.rec_segment.to_edifact).to eq(
    "REC+sammel_nummer:001+#{Time.now.strftime("%Y%m%e")}+0'"
  ) }

  it { expect(subject.ust_segment.to_edifact).to eq(
    "UST+steuernummer+J'"
  ) }

  it { expect(subject.sko_segment.to_edifact).to eq(
    "SKO+0+5'"
  ) }

  it { expect(subject.ges_segment.to_edifact).to eq(
    "GES+00+gesbetrag+brubetrag+zubetrag'"
  ) }

  it { expect(subject.nam_segment.to_edifact).to eq(
    "NAM+Firma+partner tel+E-Mail'"
  ) }

  it { expect(subject.to_edifact).to include(
    "UNH+00123+SLGA:12:0:0'",
    "FKT+01+N+IK5430684+IK8234568+IK8643456+IK5924783'",
    "REC+sammel_nummer:001+#{Time.now.strftime("%Y%m%e")}+0'",
    "UST+steuernummer+J'",
    "SKO+0+5'",
    "GES+00+gesbetrag+brubetrag+zubetrag'",
    "NAM+Firma+partner tel+E-Mail'",
    "UNT+8+00123'"
  ) }


end
