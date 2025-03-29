import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'SweetBalance',
    url: 'https://sweetbalance.app',
  );
  OpenFoodAPIConfiguration.globalLanguages = [
    OpenFoodFactsLanguage.ENGLISH,
    OpenFoodFactsLanguage.MODERN_GREEK,
  ];
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CYPRUS;

  runApp(const MyApp());
}
