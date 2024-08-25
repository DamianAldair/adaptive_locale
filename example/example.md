# Example

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdaptiveLocale.ensureInitialized();
  runApp(const MyApp());
}

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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          title: 'Adaptive Locale Example',
          home: const Screen1(),
        );
      },
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    const packageName = 'adaptive_locale';
    const dev = 'Damian Aldair';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.example),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              packageName,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(loc.developedBy(dev)),
            const SizedBox(height: 50.0),
            ElevatedButton(
              child: Text(loc.nextScreen),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Screen2()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final localeManager = AdaptiveLocale.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.example),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
                localeManager.locale?.toLanguageTag() ?? loc.system,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(loc.select),
              trailing: PopupMenuButton<Locale>(
                itemBuilder: (BuildContext context) {
                  return localeManager.supportedLocales
                      .map((locale) => PopupMenuItem<Locale>(
                            value: locale,
                            child: Text(locale.toLanguageTag()),
                          ))
                      .toList();
                },
                onSelected: (Locale locale) {
                  localeManager.locale = locale;
                },
              ),
            ),
            TextButton(
              child: Text(loc.system),
              onPressed: () {
                localeManager.locale = null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

```