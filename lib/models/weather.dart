import 'package:equatable/equatable.dart';
import 'package:weather/utilities/store.dart';

class Weather extends Equatable implements Storable<Weather> {
  const Weather(
      {required this.temperature,
      required this.windSpeed,
      required this.weatherCode,
      required this.temperatures});

  final double temperature;
  final double windSpeed;
  final WeatherCode weatherCode;
  final List<double> temperatures;

  factory Weather.fromMap(Map<String, dynamic> map, List<double> temperatures) {
    return Weather(
        temperature: map['temperature'],
        windSpeed: map['windspeed'],
        weatherCode: WeatherCode(map['weathercode']),
        temperatures: temperatures);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'windspeed': windSpeed,
      'weathercode': weatherCode.code,
      'temperatures': temperatures,
      'updatedAt': DateTime.now().millisecondsSinceEpoch
    };
  }

  String get desc => weatherCode.desc();
  String get image => weatherCode.image();
  double get maxTemp =>
      temperatures.reduce((curr, next) => curr > next ? curr : next);
  double get minTemp =>
      temperatures.reduce((curr, next) => curr < next ? curr : next);

  @override
  List<Object?> get props => [temperature, windSpeed];

  @override
  String get docId => DateTime.now().toIso8601String();
}

class WeatherCode extends Equatable {
  const WeatherCode(this.code);
  final int code;

  String image() {
    switch (code) {
      case 0:
      case 1:
        {
          return 'assets/images/clear.png';
        }
      case 2:
      case 3:
      case 45:
      case 48:
        {
          return 'assets/images/cloud.png';
        }
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        {
          return 'assets/images/rain.png';
        }
      case 71:
      case 73:
      case 75:
      case 77:
        {
          return 'assets/images/clear.png';
        }
      case 80:
      case 81:
      case 82:
        {
          return 'assets/images/rain.png';
        }
      case 85:
      case 86:
        {
          return 'assets/images/clear.png';
        }
      case 95:
      case 96:
      case 99:
        {
          return 'assets/images/thunderstorm.png';
        }
      default:
        {
          return '-';
        }
    }
  }

  String desc() {
    switch (code) {
      case 0:
        {
          return 'Clear Sky';
        }
      case 1:
        {
          return 'Mainly Clear';
        }
      case 2:
        {
          return 'Partly Cloudy';
        }
      case 3:
        {
          return 'Overcast';
        }
      case 45:
        {
          return 'Fog';
        }
      case 48:
        {
          return 'Depositing Rime Fog';
        }
      case 51:
        {
          return 'Drizzle: Light';
        }
      case 53:
        {
          return 'Drizzle: Moderate';
        }
      case 55:
        {
          return 'Drizzle: Dense';
        }
      case 56:
        {
          return 'Freezing Drizzle: Light';
        }
      case 57:
        {
          return 'Freezing Drizzle: Dense';
        }
      case 61:
        {
          return 'Rain: Slight';
        }
      case 63:
        {
          return 'Rain: Moderate';
        }
      case 65:
        {
          return 'Rain: Heavy';
        }
      case 66:
        {
          return 'Freezing Rain: Light';
        }
      case 67:
        {
          return 'Freezing Rain: Heavy';
        }
      case 71:
        {
          return 'Snow Fall: Slight';
        }
      case 73:
        {
          return 'Snow Fall: Moderate';
        }
      case 75:
        {
          return 'Snow Fall: Heavy';
        }
      case 77:
        {
          return 'Snow Grains';
        }
      case 80:
        {
          return 'Rain Showers';
        }
      case 81:
        {
          return 'Rain Moderate';
        }
      case 82:
        {
          return 'Rain Violent';
        }
      case 85:
        {
          return 'Snow Showers: Slight';
        }
      case 86:
        {
          return 'Snow Showers: Heavy';
        }
      case 95:
        {
          return 'Thunderstorm: Slight or Moderate';
        }
      case 96:
        {
          return 'Thunderstorm with Slight Hail';
        }
      case 99:
        {
          return 'Thunderstorm with Heavy Hail';
        }
      default:
        {
          return '-';
        }
    }
  }

  @override
  List<Object?> get props => [code];
}
