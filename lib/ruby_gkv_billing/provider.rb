require 'edifact_tools'

module RubyGkvBilling
  class Provider
    TRANSMISSION_PROTOCOLS = {
      "016" => "FTAM",
      "023" => "FTP",
      "070" => "E-Mail/Internet"
    }

    TRANSMISSION_DAYS = {
      "1" => "Übertragung an allen Tagen",
      "2" => "Übertragung nur an Werktage (Montag bis Samstag außer Feiertag)",
      "3" => "Übertragung nur an Arbeitstagen (Montag bis Freitag außer Feiertag)"
    }

    attr_accessor :provider_message, :data_receipient_message

    def initialize(provider_category, client_idk, billing_code)
      load_provider_file(provider_category, client_idk, billing_code)
    end

    def load_provider_file(provider_category, client_idk, billing_code)
      provider_file = RubyGkvBilling::ProviderFile.new(provider_category)
      contact_messages = provider_file.contact_messages(client_idk, billing_code)
      @provider_message = contact_messages[:provider_message]
      @data_receipient_message = contact_messages[:data_receipient_message]
    end

    def provider_ik
      ik("provider")
    end

    def provider_short_name
      short_name("provider")
    end

    def provider_full_name
      full_name("provider")
    end

    def provider_addresses
      addresses("provider")
    end

    def provider_contact_persons
      contact_persons("provider")
    end

    def data_receipient_ik
      ik("data_receipient")
    end

    def data_receipient_short_name
      short_name("data_receipient")
    end

    def data_receipient_full_name
      full_name("data_receipient")
    end

    def data_receipient_addresses
      addresses("data_receipient")
    end

    def data_receipient_contact_persons
      contact_persons("data_receipient")
    end

    def data_receipient_transmissions
      transmissions = []
      transmission_segments = @data_receipient_message.data_entry("Segment_DFÜ") if @data_receipient_message
      if transmission_segments
        transmission_segments.each do |s|
          transmission = {}

          protocol = s["Übertragungsprotokoll"]
          if TRANSMISSION_PROTOCOLS[protocol]
            protocol = TRANSMISSION_PROTOCOLS[protocol]
          end
          transmission[:protocol] = protocol

          transmission[:user_id] = s["Benutzerkennung"]

          t_from = s["Übertragung_von"]
          t_from = t_from.insert(2, ":") if t_from && t_from.length == 4
          transmission[:transmission_from] = t_from

          t_to = s["Übertragung_bis"]
          t_to = t_to.insert(2, ":") if t_to && t_to.length == 4
          transmission[:transmission_to] = t_to

          days = s["Übertragungstage"]
          if TRANSMISSION_DAYS[days]
            days = TRANSMISSION_DAYS[days]
          end
          transmission[:transmission_days] = days
          transmission[:communication_channel] = s["Kommunikationskanal"]
          transmissions.push(transmission)
        end
      end
      transmissions
    end

    private

    def ik(message_type)
      message = self.send("#{message_type}_message")
      message.data_entry("Segment_Identifikation", "Institutionskennzeichen") if message
    end

    def short_name(message_type)
      message = self.send("#{message_type}_message")
      message.data_entry("Segment_Identifikation", "Kurzbezeichnung") if message
    end

    def full_name(message_type)
      full_name = ""
      ["Name-1", "Name-2", "Name-3", "Name-4"].each_with_index do |n, i|
        message = self.send("#{message_type}_message")
        name = message.data_entry("Segment_Name", n) if message
        if name
          full_name.concat(" ") if i != 0
          full_name.concat(name)
        end
      end

      if !full_name.empty?
        full_name
      else
        nil
      end
    end

    def addresses(message_type)
      addresses = []
      message = self.send("#{message_type}_message")
      address_segments = message.data_entry("Segment_Anschrift") if message
      if address_segments
        address_segments.each do |s|
          address = {}
          address[:code] = s["Postleitzahl"]
          address[:city] = s["Ort"]
          address[:street] = s["Straße,Hausnr/Postfach"]
          addresses.push(address)
        end
      end
      addresses
    end

    def contact_persons(message_type)
      contact_persons = []
      message = self.send("#{message_type}_message")
      contact_person_segments = message.data_entry("Segment_Ansprechpartner") if message
      if contact_person_segments
        contact_person_segments.each do |p|
          contact_person = {}
          contact_person[:phone] = p["Telefon"]
          contact_person[:fax] = p["Fax"]
          contact_person[:name] = p["Name"]
          contact_person[:working_area] = p["Arbeitsgebiet_des_Ansprechpartners"]
          contact_persons.push(contact_person)
        end
      end
      contact_persons
    end
  end
end
