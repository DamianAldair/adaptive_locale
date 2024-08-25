import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'adaptive_locale.dart';

abstract class LocalePreferences {
  static late SharedPreferences _prefs;
  static late Locale? _currentLocale;

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

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    final jsonStringPrefs = _prefs.getString(AdaptiveLocale.prefKey);
    final mapPrefs = jsonStringPrefs == null
        ? <String, dynamic>{}
        : json.decode(jsonStringPrefs) as Map<String, dynamic>;

    if (mapPrefs.containsKey('current_locale')) {
      final localeMap = mapPrefs['current_locale'] as Map<String, dynamic>;
      _currentLocale = Locale(
        localeMap['language_code'],
        localeMap['country_code'],
      );
    }
  }

  static Locale? get currentLocale => _currentLocale;

  static set currentLocale(Locale? locale) {
    _currentLocale = locale;
    save();
  }
}
