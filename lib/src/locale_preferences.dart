import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'adaptive_locale.dart';

/// Utility for storing locale info in SharedPreferences.
abstract class LocalePreferences {
  static late SharedPreferences _prefs;
  static late Locale? _currentLocale;

  /// Save current locale info in SharedPreferences.
  static void save() {
    final map = {
      if (_currentLocale != null)
        'current_locale': {
          'language_code': _currentLocale?.languageCode,
          'country_code': _currentLocale?.countryCode,
        },
    };
    final jsonString = json.encode(map);
    _prefs.setString(AdaptiveLocale.prefKey, jsonString);
  }

  /// Set up the locale preferences to be used by the app.
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    final jsonStringPrefs = _prefs.getString(AdaptiveLocale.prefKey);
    final mapPrefs = jsonStringPrefs == null
        ? <String, dynamic>{}
        : json.decode(jsonStringPrefs) as Map<String, dynamic>;

    if (!mapPrefs.containsKey('current_locale')) {
      _currentLocale = null;
    } else {
      final localeMap = mapPrefs['current_locale'] as Map<String, dynamic>;
      _currentLocale = Locale(
        localeMap['language_code'],
        localeMap['country_code'],
      );
    }
  }

  /// Get the `Locale`.
  static Locale? get currentLocale => _currentLocale;

  /// Set and storage the `Locale`.
  static set currentLocale(Locale? locale) {
    _currentLocale = locale;
    save();
  }
}
