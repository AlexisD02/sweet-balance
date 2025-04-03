import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:sweet_balance/service/location_service.dart';
import 'package:sweet_balance/utils/country_mapper.dart';

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

  try {
    final isoCode = await LocationService.detectUserCountry();
    if (isoCode != null) {
      OpenFoodAPIConfiguration.globalCountry = mapIsoCodeToOpenFoodFactsCountry(isoCode); // set the country based on location code of the user
    }
    else {
      OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.USA; // if not found set the default one
    }
  } catch (e) {
    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.USA; // fallback on failure
  }

  runApp(const MyApp());
}