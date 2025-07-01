import 'package:flutter/foundation.dart'; // Per kDebugMode
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Per json.encode e json.decode

// Classe per le impostazioni dell'app
class AppSettings {
  final String remoteXmlRoot;
  final String remoteXmlRoutesUrl;
  final String? password; // Campo password aggiunto, può essere nullo

  AppSettings({
    required this.remoteXmlRoot,
    required this.remoteXmlRoutesUrl,
    this.password, // Rendi il parametro opzionale e nullable
  });

  // Metodo per convertire le impostazioni in una mappa per shared_preferences
  Map<String, dynamic> toJson() => {
    'remoteXmlRoot': remoteXmlRoot,
    'remoteXmlRoutesUrl': remoteXmlRoutesUrl,
    'password': password, // Includi la password
  };

  // Metodo per creare le impostazioni da una mappa (es. da shared_preferences o QR)
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      remoteXmlRoot: json['remoteXmlRoot'] as String,
      remoteXmlRoutesUrl: json['remoteXmlRoutesUrl'] as String,
      password: json['password'] as String?, // Leggi la password, può essere nulla
    );
  }
}

// Servizio per gestire il caricamento e il salvataggio delle impostazioni
class SettingsService {
  static const String _settingsKey = 'appSettings';

  static Future<AppSettings?> loadAppSettings() async {
    if (kDebugMode) print('SETTINGS_DEBUG: Caricamento impostazioni dall\'archiviazione locale...');
    final prefs = await SharedPreferences.getInstance();
    final String? settingsJson = prefs.getString(_settingsKey);

    if (settingsJson != null) {
      if (kDebugMode) print('SETTINGS_DEBUG: Impostazioni trovate: $settingsJson');
      try {
        final Map<String, dynamic> jsonMap = json.decode(settingsJson);
        final settings = AppSettings.fromJson(jsonMap);
        if (kDebugMode) print('SETTINGS_DEBUG: Impostazioni caricate con successo.');
        return settings;
      } catch (e) {
        if (kDebugMode) print('SETTINGS_ERROR: Errore nel parsing delle impostazioni salvate: $e');
        await prefs.remove(_settingsKey); // Rimuovi le impostazioni corrotte
        return null;
      }
    }
    if (kDebugMode) print('SETTINGS_DEBUG: Nessuna impostazione trovata.');
    return null;
  }

  static Future<void> saveAppSettings(AppSettings settings) async {
    if (kDebugMode) print('SETTINGS_DEBUG: Salvataggio impostazioni: ${settings.toJson()}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, json.encode(settings.toJson()));
    if (kDebugMode) print('SETTINGS_DEBUG: Impostazioni salvate con successo.');
  }
}
