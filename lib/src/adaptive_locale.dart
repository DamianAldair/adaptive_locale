import 'package:flutter/widgets.dart';

import 'locale_manager.dart';
import 'locale_preferences.dart';

typedef AdaptiveLocaleBuilder = Widget Function(
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Iterable<Locale> supportedLocales,
  Locale? currentLocale,
);

class AdaptiveLocale extends StatefulWidget {
  static const String prefKey = 'adaptive_locale_preferences';

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? initialLocale;
  final AdaptiveLocaleBuilder builder;

  const AdaptiveLocale({
    Key? key,
    this.localizationsDelegates,
    required this.supportedLocales,
    this.initialLocale,
    required this.builder,
  }) : super(key: key);

  @override
  State<AdaptiveLocale> createState() => _AdaptiveLocaleState();

  static Future<void> ensureInitialized() => LocalePreferences.initialize();

  static LocaleManager? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<State<AdaptiveLocale>>()
        as _AdaptiveLocaleState?;
    return state?.manager;
  }

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
