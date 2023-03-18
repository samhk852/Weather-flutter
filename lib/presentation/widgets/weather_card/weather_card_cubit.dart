import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_service.dart';

part 'weather_card_state.dart';

class WeatherCardCubit extends Cubit<WeatherCardState> {
  WeatherCardCubit(this._weatherService, this._location)
      : super(WeatherCardInit()) {
    _init();
  }

  final WeatherService _weatherService;
  final Location _location;

  void _init() {
    _load();
  }

  void _load() {
    _weatherService
        .getWeatherBy(_location)
        .then((weather) => emit(WeatherCardLoaded(weather)));
  }
}
