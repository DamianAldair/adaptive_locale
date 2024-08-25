import 'package:flutter/widgets.dart';

import 'locale_manager.dart';
import 'locale_preferences.dart';

/// Builder function to build localized widgets
typedef AdaptiveLocaleBuilder = Widget Function(
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale> supportedLocales,
  Locale? currentLocale,
);

/// Widget that allows to switch locales dynamically. This is intended to be
/// used above [MaterialApp] or [CupertinoApp].
///
/// Example:
///
/// ```dart
/// AdaptiveLocale(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   builder: (localizationsDelegates, supportedLocales, currentLocale) {
///     return MaterialApp(
///       localizationsDelegates: localizationsDelegates,
///       supportedLocales: supportedLocales,
///       locale: currentLocale,
///       title: 'Adaptive Locale',
///       home: const MyHomePage(),
///     );
///   },
/// );
/// ```
class AdaptiveLocale extends StatefulWidget {
  /// Key used to store theme information into SharedPreferences. If you want
  /// to persist theme mode changes even after SharedPreferences
  /// is cleared (e.g. after log out), do not remove this [prefKey] key from
  /// SharedPreferences.
  static const String prefKey = 'adaptive_locale_preferences';

  /// Internationalized apps that require translations for one of the locales
  /// listed in [GlobalMaterialLocalizations] should specify this parameter
  /// and list the [supportedLocales] that the application can handle.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

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
  final Iterable<Locale> supportedLocales;

  /// Indicates which [Locale] to use initially.
  ///
  /// If it is `null`, system locale will be used.
  final Locale? initialLocale;

  /// Provides a builder with access of locale related stuff. Intended to
  /// be used to return [MaterialApp] or [CupertinoApp].
  final AdaptiveLocaleBuilder builder;

  /// Primary constructor which allows to configure locales initially.
  const AdaptiveLocale({
    super.key,
    this.localizationsDelegates,
    required this.supportedLocales,
    this.initialLocale,
    required this.builder,
  });

  @override
  State<AdaptiveLocale> createState() => _AdaptiveLocaleState();

  /// Ensure proper initialization.
  /// It must be used in the main function, before [runApp].
  /// It is highly recommended to use
  /// [WidgetsFlutterBinding.ensureInitialized].
  ///
  /// Example:
  ///
  /// ```dart
  /// Future<void> main() async {
  ///  WidgetsFlutterBinding.ensureInitialized();
  ///  await AdaptiveLocale.ensureInitialized();
  ///  runApp(const MyApp());
  /// }
  /// ```
  static Future<void> ensureInitialized() => LocalePreferences.initialize();

  /// Returns reference of the [LocaleManager] used for manage locale related
  /// stuff.
  ///
  /// This returns null if the state instance of [LocaleManager] is not found.
  static LocaleManager? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<State<AdaptiveLocale>>()
        as _AdaptiveLocaleState?;
    return state?.manager;
  }

  /// Returns reference of the [LocaleManager] used for manage locale related
  /// stuff.
  static LocaleManager of(BuildContext context) => maybeOf(context)!;
}

class _AdaptiveLocaleState extends State<AdaptiveLocale> {
  late LocaleManager manager;

  @override
  void initState() {
    super.initState();
    manager = LocaleManager(
      localizationsDelegates: widget.localizationsDelegates,
      supportedLocales: widget.supportedLocales,
      initialLocale: widget.initialLocale,
    );
  }

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: manager.localeNotifier,
      builder: (BuildContext context, Locale? locale, Widget? child) {
        return widget.builder(
          manager.localizationsDelegates,
          manager.supportedLocales,
          locale,
        );
      },
    );
  }
}
