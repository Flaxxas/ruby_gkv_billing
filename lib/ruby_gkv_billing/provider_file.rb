# Kostentraegerdatei
# https://www.gkv-datenaustausch.de/media/dokumente/leistungserbringer_1/sonstige_leistungserbringer/technische_anlagen_aktuell_4/Anhang_03_Anlage_1_TP5_20170920.pdf
require 'edifact_tools'

module RubyGkvBilling
  class ProviderFile
    def initialize(provider_name)
      load_file(provider_name)
    end

    def dfu_for_client(client_idk, billing_code, tarif_nr = nil)
      message = search_by_ik(client_idk)
      vkgs = message.data_entry("Segment_Verknüpfung") if message

      if vkgs && !vkgs.empty?
        if vkgs.length == 1
          vkg = vkgs.first
          mediator_ik = vkg["IK_des_Verknüpfungspartners"] if vkg["Art_der_Verknüpfung"] == "01"
          message = search_by_ik(mediator_ik)
          vkgs = message.data_entry("Segment_Verknüpfung")
        end

        if vkgs.length > 1
          vkgs.first["Art_der_Verknüpfung"] == "01" &&
          vkgs.first["IK_des_Verknüpfungspartners"] == mediator_ik

          comm_partner = vkgs.select {|vkg| vkg["Art_der_Verknüpfung"] == "03" && vkg["Art_der_Datenlieferung"] == "07"}

          comm_partner_with_matching_billing_code = comm_partner.select {|vkg| vkg["Abrechnungscode"] == billing_code}
          comm_partner_with_matching_billing_code = comm_partner.select {|vkg| vkg["Abrechnungscode"] == billing_code[0].concat("0")} if comm_partner_with_matching_billing_code.empty?
          comm_partner_with_matching_billing_code = comm_partner.select {|vkg| vkg["Abrechnungscode"] == "00"} if comm_partner_with_matching_billing_code.empty?
          if comm_partner_with_matching_billing_code.length == 1
            comm_partner_ik = comm_partner_with_matching_billing_code.first["IK_des_Verknüpfungspartners"]
            return communications_for_ik(comm_partner_ik)
          end
        end
      end

      return nil
    end

    def communications_for_ik(nr)
      message = search_by_ik(nr)
      message.data_entry("Segment_DFÜ", "Kommunikationskanal")
    end

    def search_by_ik(nr)
      messages.select {|m| m.data_entry("Segment_Identifikation", "Institutionskennzeichen") == nr}.first
    end

    def billing_category
      EdifactTools::EdifactParser.billing_codes[@data.billing_code]
    end

    def messages
      @messages ||= @data.non_storno_messages
    end

    def load_file(provider_name)
      @data = EdifactTools::EdifactParser.read(provider_name)
    end

    def dataname
      @data.dataname
    end

    def self.billing_category(billing_code)
      EdifactTools::EdifactParser.billing_codes[billing_code]
    end

    private

    def search_attribute(message, segment_name, segment_attribute)
      message.data_entry(segment_name, segment_attribute) if message
    end
  end
end
