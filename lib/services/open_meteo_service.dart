import 'dart:convert';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/geocoding_service.dart';
import 'package:weather/services/weather_service.dart';
import 'package:http/http.dart' as http;
import 'package:weather/utilities/store.dart';
import 'package:weather/utilities/constants.dart' as constant;

class OpenMeteoService implements WeatherService, GeocodingService {
  OpenMeteoService(this._store);

  final Store _store;

  @override
  Future<List<Location>> searchLocations(String keyword) {
    final url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': keyword,
    });
    final result = http
        .get(url)
        .then((response) => jsonDecode(response.body))
        .then((json) => json['results'] as List<dynamic>)
        .then((json) => json.map((e) => Location.fromMap(e)).toList())
        .onError((error, stackTrace) => []);
    return result;
  }

  @override
  Future<Weather> getWeatherBy(Location location) async {
    final url = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${location.latitude}',
      'longitude': '${location.longitude}',
      'hourly': 'temperature_2m',
      'current_weather': 'true',
    });

    // check cache
    if (await _store.exist(StoreCollection.weather, location.docId)) {
      final doc = await _store.get(StoreCollection.weather, location.docId);
      if (doc != null) {
        final updatedAt = doc['updatedAt'];
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = (now - updatedAt) / 1000;
        if (diff < constant.cacheExpireTime) {
          final weather = Weather.fromMap(
              doc, (doc['temperatures'] as List<dynamic>).cast<double>());
          return Future.value(weather);
        }
      }
    }

    final result = http
        .get(url)
        .then(
          (response) => jsonDecode(response.body),
        )
        .then((result) {
      final temperatures =
          (result['hourly']['temperature_2m'] as List<dynamic>).cast<double>();
      final weather = Weather.fromMap(result['current_weather'], temperatures);
      _store.save(StoreCollection.weather, weather, docId: location.docId);
      return weather;
    }).onError((error, stackTrace) {
      throw Error();
    });
    return result;
  }
}
