import 'dart:convert';

import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/common/contextextension.dart';
import 'package:crm_generatewealthapp/CRM/contact/notify.dart';
import 'package:crm_generatewealthapp/loader.dart';
import 'package:crm_generatewealthapp/Accounting/provider/Accountsprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/Userprovider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.initNotifications();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
    ChangeNotifierProvider<Userprovider>(create: (_) => Userprovider()),
    ChangeNotifierProvider<Accountsprovider>(create: (_) => Accountsprovider()),
    ChangeNotifierProvider<Crmprovider>(create: (_) => Crmprovider()),
  ], child: MyApp(key: myAppKey)));
}

final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _localeFuture = localechange();
    super.initState();
  }

  Locale? _locale;
  late Future<void> _localeFuture;

  Future<void> localechange() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('Locale')) {
      final String userLanguage = prefs.getString('Locale') ?? '';
      // await context.readuser.loggeduser(userdata);

      if (userLanguage.isNotEmpty) {
        if (userLanguage == 'Tamil') {
          await context.readuser.updatelanguage(userLanguage);

          setState(() {
            _locale = Locale('ta', '');
          });
        } else {
          _locale = Locale('en', '');
        }
      } else {
        _locale = Locale('en', '');
      }
    } else {
      _locale = Locale('en', '');
    }
  }

  void changeLanguage(Locale locale) {
    _locale = locale;
    print(_locale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizationsDelegate.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ta', ''),
        ],
        locale: _locale,
        theme: Provider.of<ThemeProvider>(context).currentTheme,
        home: Loader(),
      ),
    );
  }
}

class AppLocalizations {
  Map<String, String> _localizedStrings = {};

  Future<void> load(Locale locale) async {
    String jsonContent = await rootBundle
        .loadString('assets/locale/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonContent);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static AppLocalizations of(BuildContext context) {
    // assert(debugCheckHasMaterialLocalizations(context));
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(
    String key,
  ) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
  static final Map<Locale, Future<AppLocalizations>> _loadedTranslations =
      <Locale, Future<AppLocalizations>>{};

  @override
  bool isSupported(Locale locale) => ['en', 'ta'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    assert(isSupported(locale));

    return _loadedTranslations.putIfAbsent(locale, () async {
      final localizations = AppLocalizations();

      await localizations.load(locale);
      // print("hi2");
      // print("hekll" + localizations.translate("title"));
      return localizations;
    });
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
