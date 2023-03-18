import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract class WeatherService {
  Future<Weather> getWeatherBy(Location location);
}
