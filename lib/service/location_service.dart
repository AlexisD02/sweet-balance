import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /*
    Attempts to determine the user's current country based on their location.
    This to identify which products of which country to provide to the user based on his location
    Returns the ISO country code (e.g., "US", "GB").
  */
  static Future<String?> detectUserCountry() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Here check if the location services are enabled at the system level before
    // we can access any location data.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Checks if our app has permission to access location data.
    // Apps need explicit user consent, and permissions can be denied or restricted.
    permission = await Geolocator.checkPermission();

    // If permission was denied, try requesting it once.
    // Users might have denied it temporarily or skipped it during onboarding.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // If the user still denies permission, we cannot proceed.
      // It's respectful UX to stop here and notify instead of nagging.
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    // If permission was denied forever, the app cannot ask again.
    // In that case let the user know they must change settings manually.
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied, we cannot request permissions.',
      );
    }

    // We now have permission and can attempt to retrieve the user’s current latitude and longitude coordinates.
    final position = await Geolocator.getCurrentPosition();

    // In order to get the country code (geocoding), we convert the latitude/longitude.
    // This gives us the country, region, and city.
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // If we got a valid placemark with a country code, we return it.
    if (placemarks.isNotEmpty && placemarks.first.isoCountryCode != null) {
      return placemarks.first.isoCountryCode!;
    }

    // If no valid placemark is found, we throw to indicate failure.
    throw Exception('Could not determine country.');
  }
}
