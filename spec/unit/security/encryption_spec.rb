RSpec.describe RubyGkvBilling::Security::Encryption do
  let(:private_key) { File.join(RubyGkvBilling.root, 'spec/examples/private_1234567_key.pem') }
  let(:key) { RubyGkvBilling::Security::Certification.open_key(private_key) }
  let(:data) { 'TestDaten' }

  let(:crt_path) { File.join(RubyGkvBilling.root, "spec/examples/certificate_1234567.pem") }
  let(:crt) { RubyGkvBilling::Security::Certification.open_crt(crt_path) }

  describe 'signing' do
    subject { RubyGkvBilling::Security::Encryption.sign(key, data) }

    it 'should verfiy data' do
      expect(RubyGkvBilling::Security::Encryption.verify(key, subject, data)).to be_truthy
    end
  end
end
