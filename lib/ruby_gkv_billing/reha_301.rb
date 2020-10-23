require 'ruby_gkv_billing/reha_301/xml'

# https://www.gkv-datenaustausch.de/leistungserbringer/reha_einrichtungen/reha_einrichtungen.jsp
# https://www.deutsche-rentenversicherung.de/DRV/DE/Experten/Infos-fuer-Reha-Einrichtungen/Klassifikationen-und-Dokumentationshilfen/klassifikationen_dokumentationshilfen.html

module RubyGkvBilling
  module Reha301
    FEHLERCODES = {
      "00000" => "positive Quittung, kein Fehler",
      "00001" => "positive Quittung mit Hinweis",
      "01000" => "Validierungsfehler aufgetreten",
      "01001" => "Die Schema -Version ist ungültig oder nicht bekannt",
      "01002" => "Die Fall-ID ist für den RV-Träger gedacht / Die Fall-ID ist für den KV-Träger gedacht",
      "01003" => "Der Geschäftsvorfall ist nicht erlaubt",
      "01004" => "Erstellungstag und Uhrzeit der Datei > Tag und Uhrzeit der Verarbeitung",
      "01005" => "IK Absender der Datei nicht als Kommunikationspartner bekannt",
      "01006" => "IK Empfänger der Datei nicht annehmende Stelle",
      "01007" => "Nutzdatendatei nicht lesbar",
      "02000" => "Fehler aus Fachverfahren"
    }

    FALLARTEN = {
      "01" => "Aufnahme",
      "03" => "Antrag auf Verlängerung des Aufenthaltes",
      "04" => "Entlassungsmeldung",
      "06" => "Unterbrechung",
      "07" => "Absage durch die Einrichtung",
      "10" => "Anzeige einer Verlängerung",
      "11" => "Bewilligung",
      "12" => "Absage durch den Kostenträger",
      "13" => "Ergänzungen vor Reha-Beginn",
      "15" => "Antwort zum Antrag auf Verlängerung des Aufenthaltes",
      "16" => "Antrag auf Verlängerung der Kostenzusage",
      "17" => "Antwort zum Antrag auf Verlängerung der Kostenzusage",
      "18" => "Antrag auf Phasenwechsel",
      "19" => "Antwort zum Antrag auf Phasenwechsel",
      "21" => "Entlassungsbericht",
      "30" => "Rechnung",
      "31" => "Zahlsatz",
      "32" => "Zuzahlungsgutschrift / -rückforderung",
      "80" => "Fehlermeldung"
    }

    DRV_FALLART = {
      "01" => "Aufnahme",
      "03" => "Antrag auf Verlängerung des Aufenthaltes",
      "04" => "Entlassungsmeldung",
      "06" => "Unterbrechung",
      "07" => "Absage durch die Einrichtung",
      "10" => "Anzeige einer Verlängerung",
      "11" => "Bewilligung",
      "12" => "Absage durch den Kostenträger",
      "13" => "Ergänzungen vor Reha-Beginn",
      "15" => "Antwort zum Antrag auf Verlängerung des Aufenthaltes",
      "16" => "Antrag auf Verlängerung der Kostenzusage",
      "17" => "Antwort zum Antrag auf Verlängerung der Kostenzusage",
      "21" => "Entlassungsbericht",
      "30" => "Rechnung",
      "31" => "Zahlsatz",
      "80" => "Fehlermeldung"
    }

    GKV_FALLART = {
      "01" => "Aufnahme",
      "03" => "Antrag auf Verlängerung des Aufenthaltes",
      "04" => "Entlassungsmeldung",
      "06" => "Unterbrechung",
      "07" => "Absage durch die Einrichtung",
      "11" => "Bewilligung",
      "15" => "Antwort zum Antrag auf Verlängerung des Aufenthaltes",
      "18" => "Antrag auf Phasenwechsel",
      "19" => "Antwort zum Antrag auf Phasenwechsel",
      "30" => "Rechnung",
      "31" => "Zahlsatz",
      "32" => "Zuzahlungsgutschrift / -rückforderung",
      "80" => "Fehlermeldung"
    }
  end
end
