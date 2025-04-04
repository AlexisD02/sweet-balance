import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String?> detectUserCountry() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty && placemarks.first.isoCountryCode != null) {
      return placemarks.first.isoCountryCode!;
    }

    throw Exception('Could not determine country.');
  }
}
