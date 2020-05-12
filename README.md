# RubyGkvBilling

ruby_gkv_billing is a library to generate *EDIFACT*-files for the purpose of [electonic billing with "Gesetzlichen Krankenkassen (GKV)"](https://www.gkv-datenaustausch.de/)

## Documentation (german)

* [wiki](https://github.com/Sektor-N/ruby_gkv_billing/wiki)
* [Technische Standards](https://www.gkv-datenaustausch.de/media/dokumente/leistungserbringer_1/sonstige_leistungserbringer/technische_anlagen_aktuell_4/Anlage_1_TP5_V12_20190207.pdf)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_gkv_billing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_gkv_billing

## Usage

### Create an certification request (with keys)

    $ RubyGkvBilling::Security::Certification.create_certificate_request!(
         target_folder,
         "123456789", # IK-Nummer
         "OrgansiationsName",
         "Ansprechpartner"
      )

This command will generate a private and the public key in the `target_folder`. In addition an certification-requeset with **.p10**-ending will be placed in the same folder.

### print hash code of a key (for certification)

    $ RubyGkvBilling::Security::Certification.hash_code(key)

where `key` is a key-object opened by `RubyGkvBilling::Security::Certification.open_key`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sektor-N/ruby_gkv_billing

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
