RSpec.describe RubyGkvBilling do
  it "has a version number" do
    expect(RubyGkvBilling::VERSION).not_to be nil
  end

  it "has correct gem url" do
    expect(RubyGkvBilling.file_path("test.key")).to include("ruby_gkv_billing/test.key")
  end
end
