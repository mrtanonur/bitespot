import 'package:bitespot/l10n/app_localizations.dart';
import 'package:bitespot/local_data_source/favorite_local_data_source.dart';
import 'package:bitespot/local_data_source/main_local_data_source.dart';
import 'package:bitespot/models/restaurant_model.dart';
import 'package:bitespot/pages/splash_page.dart';
import 'package:bitespot/providers/auth_provider.dart';
import 'package:bitespot/providers/favorite_provider.dart';
import 'package:bitespot/providers/location_provider.dart';
import 'package:bitespot/providers/main_provider.dart';
import 'package:bitespot/utils/themes/dark_theme.dart';
import 'package:bitespot/utils/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(RestaurantModelAdapter());
  await MainLocalDataSource.openBox();
  await FavoriteLocalDataSource.openBox();
  // await FavoriteLocalDataSource.clear();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<MainProvider>().theme,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(context.watch<MainProvider>().language.name),
      home: const SplashPage(),
    );
  }
}
