# Auftragsdatei
# https://www.gkv-datenaustausch.de/media/dokumente/standards_und_normen/technische_spezifikationen/Anlage_2_-_Auftragsdatei.pdf
require 'edifact_tools'

module RubyGkvBilling
  class ProviderFile
    def initialize(provider_category)
      load_file(provider_category)
    end

    def contact_messages(client_idk, billing_code)
      contact_messages = {}
      pm = provider_message(client_idk)
      if pm
        contact_messages[:provider_message] = pm
        contact_messages[:data_recipient_message] = data_recipient_message(pm, billing_code)
      end
      contact_messages
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

    # private

    def search_attribute(message, segment_name, segment_attribute)
      message.data_entry(segment_name, segment_attribute) if message
    end

    def provider_message(client_idk)
      message = search_by_ik(client_idk)
      vkgs = message.data_entry("Segment_Verknüpfung") if message
      reference_to_other_provider = vkgs.select {|vkg| vkg["Art_der_Verknüpfung"] == "01" && vkg["IK_des_Verknüpfungspartners"] != client_idk} if vkgs
      references_to_data_recipient = vkgs.select {|vkg| vkg["Art_der_Verknüpfung"] == "03" && vkg["Art_der_Datenlieferung"] == "07"} if vkgs
      dfü_segments = message.data_entry("Segment_DFÜ", "Kommunikationskanal") if message
      if vkgs && reference_to_other_provider && reference_to_other_provider.length == 1
        ik = reference_to_other_provider.first["IK_des_Verknüpfungspartners"]
        potential_data_recipient = search_by_ik(ik)
        potential_data_recipient_dfüs = potential_data_recipient.data_entry("Segment_DFÜ", "Kommunikationskanal") if potential_data_recipient
        if potential_data_recipient_dfüs && !potential_data_recipient_dfüs.empty?
          return message
        else
          return provider_message(ik)
        end
      # TODO: Sonderfall IDK+103711119+99+AOK NORDWEST?
      elsif dfü_segments && !dfü_segments.empty?
        return message
      end

      if reference_to_other_provider && reference_to_other_provider.empty? && !references_to_data_recipient.empty?
        return message
      end


      return nil
    end

    def data_recipient_message(provider_message, billing_code = nil)
      vkgs = provider_message.data_entry("Segment_Verknüpfung") if provider_message
      reference_to_other_provider = vkgs.select {|vkg| vkg["Art_der_Verknüpfung"] == "01" && vkg["IK_des_Verknüpfungspartners"] != provider_message.data_entry("Segment_Identifikation", "Institutionskennzeichen")} if vkgs
      references_to_data_recipient = vkgs.select {|vkg| vkg["Art_der_Verknüpfung"] == "03" && vkg["Art_der_Datenlieferung"] == "07"} if vkgs
      dfü_segments = provider_message.data_entry("Segment_DFÜ", "Kommunikationskanal") if provider_message
      if references_to_data_recipient && !references_to_data_recipient.empty?
        data_recipient_with_matching_billing_code = references_to_data_recipient.select {|vkg| vkg["Abrechnungscode"] == billing_code} if billing_code && !billing_code.empty?
        data_recipient_with_matching_billing_code = references_to_data_recipient.select {|vkg| vkg["Abrechnungscode"] == billing_code[0].concat("0")} if data_recipient_with_matching_billing_code && data_recipient_with_matching_billing_code.empty?
        data_recipient_with_matching_billing_code = references_to_data_recipient.select {|vkg| vkg["Abrechnungscode"] == "00"} if data_recipient_with_matching_billing_code && data_recipient_with_matching_billing_code.empty? || billing_code.nil? || (billing_code && billing_code.empty?)
        if data_recipient_with_matching_billing_code.length == 1
          data_recipient_ik = data_recipient_with_matching_billing_code.first["IK_des_Verknüpfungspartners"]
          data_recipient_message = search_by_ik(data_recipient_ik) if data_recipient_ik
          return data_recipient_message if !data_recipient_message.data_entry("Segment_DFÜ", "Kommunikationskanal").empty?
        end
      # TODO: Wegen Sonderfall bei AOK Plus erforderliche Prüfung? Siehe provider_spec.rb #46..
      elsif reference_to_other_provider
        references_to_data_recipient = reference_to_other_provider
        data_recipient_with_matching_billing_code = references_to_data_recipient.select {|vkg| vkg["Abrechnungscode"] == billing_code}
        data_recipient_with_matching_billing_code = references_to_data_recipient.select {|vkg| vkg["Abrechnungscode"] == billing_code[0].concat("0")} if data_recipient_with_matching_billing_code.empty?
        data_recipient_with_matching_billing_code = references_to_data_recipient.select {|vkg| vkg["Abrechnungscode"] == "00"} if data_recipient_with_matching_billing_code.empty? || billing_code.nil?
        if data_recipient_with_matching_billing_code.length == 1
          data_recipient_ik = data_recipient_with_matching_billing_code.first["IK_des_Verknüpfungspartners"]
          data_recipient_message = search_by_ik(data_recipient_ik) if data_recipient_ik
          return data_recipient_message if !data_recipient_message.data_entry("Segment_DFÜ", "Kommunikationskanal").empty?
        end
      elsif dfü_segments && !dfü_segments.empty?
        return provider_message
      end
      return nil
    end
  end
end
