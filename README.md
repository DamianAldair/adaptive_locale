# Adaptive Locale

by [Damian Aldair](https://damianaldair.github.io).

---

Inspired by [Adaptive Theme](https://pub.dev/packages/adaptive_theme).

The easiest way to handle **Locales** in your Flutter app. Allows you to set the **locale** dynamically and get the **locale** being used and all **supported locales**. It also preserves **locale** changes across app restarts.


## Getting Started

Add following dependency to your `pubspec.yaml`

```yaml
dependencies:
  adaptive_locale: <latest_version>
```


## Recommendations
Use packages for app internationalization like [`flutter_localizations`](https://pub.dev/packages/flutter_localization) and [`intl`](https://pub.dev/packages/intl).

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: <latest_version>
```
  

## Initialization

Import the package.
```dart
import 'package:adaptive_locale/adaptive_locale.dart';
```

You need to ensure proper package initialization with the following:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdaptiveLocale.ensureInitialized();
  runApp(const MyApp());
}
```


You need to wrap your `MaterialApp` or `CupertinoApp` with `AdaptiveLocale` in order to manage locales.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLocale(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (localizationsDelegates, supportedLocales, currentLocale) {
        return MaterialApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          locale: currentLocale,
          title: 'Adaptive Locale Example',
          home: const Screen(),
        );
      },
    );
  }
}
```

Now that you have initialized your app as mentioned above. It's very easy manage the locales.


## Getting all the supported locales

```dart
final Iterable<Locale> locales = AdaptiveLocale.of(context).supportedLocales;
```

## Getting current locale

```dart
final Locale? locale = AdaptiveLocale.of(context).locale;
```

If `locale` is **null** it is because the locale is being used according to the system.


## Setting locale to use
```dart
AdaptiveLocale.of(context).locale = const Locale('es');
```

This fails if the `Locale` to be set is not among the supported ones. It is recommended to check `AdaptiveLocale.of(context).supportedLocales` first.

If you set **null**, it means that it will use the system-specific `Locale`.


## Warning

> This package uses [shared_preferences](https://pub.dev/packages/shared_preferences) plugin internally to persist locale changes. If your app uses [shared_preferences](https://pub.dev/packages/shared_preferences) which might be the case all the time, clearing your [shared_preferences](https://pub.dev/packages/shared_preferences) at the time of logging out or signing out might clear these preferences too. Be careful not to clear these preferences if you want it to be persisted.

You can use `AdaptiveLocale.prefKey` to exclude it while clearing the all the preferences.

Or you can call `AdaptiveLocale.of(context).persist()` method after clearing the preferences to make it persistable again as shown below.

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
AdaptiveLocale.of(context).persist();
```