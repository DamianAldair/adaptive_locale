import 'package:flutter/widgets.dart';

import 'locale_preferences.dart';

/// Entry point to set current locale or access locales related information
/// from [AdaptiveLocale].
///
/// An instance of this can be retrieved by calling [AdaptiveLocale.of] or
/// [AdaptiveLocale.maybeOf].
class LocaleManager {
  late final Iterable<LocalizationsDelegate<dynamic>>? _localizationsDelegates;
  late final Iterable<Locale> _supportedLocales;

  /// Allows to listen to changes in the current `Locale`.
  late final ValueNotifier<Locale?> localeNotifier;

  /// Create an instance of `LocaleManager`.
  LocaleManager({
    /// Internationalized apps that require translations for one of the locales
    /// listed in [GlobalMaterialLocalizations] should specify this parameter
    /// and list the [supportedLocales] that the application can handle.
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,

    /// It is passed along unmodified to the [WidgetsApp] built by this widget.
    ///
    /// See also:
    ///
    ///  * [localizationsDelegates], which must be specified for localized
    ///    applications.
    ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value
    ///    which provides material localizations for many languages.
    ///  * The Flutter Internationalization Tutorial,
    ///    <https://flutter.dev/tutorials/internationalization/>.
    Iterable<Locale> supportedLocales = const <Locale>[
      Locale('en', 'US'),
    ],

    /// Indicates which [Locale] to use initially.
    ///
    /// If it is `null`, system locale will be used.
    Locale? initialLocale,
  }) {
    _localizationsDelegates = localizationsDelegates;
    _supportedLocales = supportedLocales;

    LocalePreferences.currentLocale ??= initialLocale;
    localeNotifier = ValueNotifier<Locale?>(
      LocalePreferences.currentLocale ?? initialLocale,
    );
  }

  /// Get the `localizationsDelegates` set at initialization.
  /// They should also have been established in the [MaterialApp] or
  /// [CupertinoApp].
  Iterable<LocalizationsDelegate<dynamic>>? get localizationsDelegates =>
      _localizationsDelegates;

  /// Get the `supportedLocales` set at initialization.
  /// They should also have been established in the [MaterialApp] or
  /// [CupertinoApp].
  Iterable<Locale> get supportedLocales => _supportedLocales;

  /// Get the current `Locale` used by the app.
  ///
  /// If it returns null, it is because system locale is being used.
  Locale? get locale => LocalePreferences.currentLocale;

  /// Set the `Locale` to be used by the app.
  /// This will fail if the locale to set is not within the supported locales.
  ///
  /// If set to null, the system locale will be used.
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

  /// This is used to persist locale related info after clearing
  /// SharedPreferences.
  void persist() => LocalePreferences.save();

  /// Helps free memory.
  void dispose() {
    localeNotifier.dispose();
  }
}
