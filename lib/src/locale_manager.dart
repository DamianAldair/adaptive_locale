import 'package:flutter/widgets.dart';

import 'locale_preferences.dart';

class LocaleManager {
  late final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  late final Iterable<Locale> _supportedLocales;
  late final ValueNotifier<Locale?> localeNotifier;

  LocaleManager({
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale> supportedLocales = const <Locale>[
      Locale('en', 'US'),
    ],
    Locale? initialLocale,
  }) {
    _localizationsDelegates = localizationsDelegates;
    _supportedLocales = supportedLocales;

    LocalePreferences.currentLocale ??= initialLocale;
    localeNotifier = ValueNotifier<Locale?>(
      LocalePreferences.currentLocale ?? initialLocale,
    );
  }

  Iterable<LocalizationsDelegate<dynamic>>? get localizationsDelegates =>
      _localizationsDelegates;

  Iterable<Locale> get supportedLocales => _supportedLocales;

  Locale? get locale => LocalePreferences.currentLocale;

  set locale(Locale? locale) {
    if (locale != null) {
      assert(
        supportedLocales.contains(locale),
        'The locale is not among the supported locales.',
      );
    }
    LocalePreferences.currentLocale = locale;
    localeNotifier.value = locale;
  }

  void persist() => LocalePreferences.save();

  void dispose() {
    localeNotifier.dispose();
  }
}
