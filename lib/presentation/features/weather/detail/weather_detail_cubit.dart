import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/utilities/store.dart';

part 'weather_detail_state.dart';

class WeatherDetailCubit extends Cubit<WeatherDetailState> {
  WeatherDetailCubit(
    this._weatherService,
    this._store,
    this._location,
  ) : super(WeatherDetailInit()) {
    _init();
  }

  final WeatherService _weatherService;
  final Store _store;
  final Location _location;

  void didTapFavourite() => _favourite();

  void _init() async {
    _load();
  }

  void _load() async {
    final favourite =
        await _store.exist(StoreCollection.favourite, _location.docId);
    _weatherService.getWeatherBy(_location).then(
        (weather) => emit(WeatherDetailLoaded(_location, weather, favourite)));
  }

  void _favourite() async {
    final isFavourited =
        await _store.exist(StoreCollection.favourite, _location.docId);
    if (isFavourited) {
      _store.delete(StoreCollection.favourite, _location.docId);
      if (state is WeatherDetailLoaded) {
        emit((state as WeatherDetailLoaded).copyWith(false));
      }
    } else {
      _store.save(StoreCollection.favourite, _location);
      if (state is WeatherDetailLoaded) {
        emit((state as WeatherDetailLoaded).copyWith(true));
      }
    }
  }
}
