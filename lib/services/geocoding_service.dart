import 'package:weather/models/location.dart';

abstract class GeocodingService {
  Future<List<Location>> searchLocations(String keyword);
}
