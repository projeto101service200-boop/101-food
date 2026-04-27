import 'package:geolocator/geolocator.dart';
import 'package:dart_geohash/dart_geohash.dart';

class LocationService {
  
  // Obter localização atual com permissões
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  // Gerar Geohash a partir de coordenadas
  String getGeohash(double lat, double lng) {
    return GeoHasher().encode(lng, lat);
  }

  // Calcular distância entre dois pontos (em metros)
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
