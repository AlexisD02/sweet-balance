import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // find user's country based on their current location.
  static Future<String?> detectUserCountry() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // checking for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // in case of denied permission, do request once
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // in case repeated denied permission, throw exception
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied, we cannot request permissions.');
    }

    // get latitude and longitute coords
    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty && placemarks.first.isoCountryCode != null) {
      return placemarks.first.isoCountryCode!;
    }

    throw Exception('Could not determine country.');
  }
}
