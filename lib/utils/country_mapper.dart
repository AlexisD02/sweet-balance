import 'package:openfoodfacts/openfoodfacts.dart';

OpenFoodFactsCountry mapIsoCodeToOpenFoodFactsCountry(String isoCode) {
  switch (isoCode.toUpperCase()) {
    case 'CY':
      return OpenFoodFactsCountry.CYPRUS;
    case 'GR':
      return OpenFoodFactsCountry.GREECE;
    case 'GB':
      return OpenFoodFactsCountry.UNITED_KINGDOM;
    case 'FR':
      return OpenFoodFactsCountry.FRANCE;
    case 'DE':
      return OpenFoodFactsCountry.GERMANY;
    default:
      return OpenFoodFactsCountry.USA;
  }
}
