part of 'weather_detail_cubit.dart';

abstract class WeatherDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherDetailInit extends WeatherDetailState {}

class WeatherDetailLoading extends WeatherDetailState {}

class WeatherDetailLoaded extends WeatherDetailState {
  WeatherDetailLoaded(this.location, this.weather, this.favourite);

  final Location location;
  final Weather weather;
  final bool favourite;

  @override
  List<Object?> get props => [location, weather, favourite];

  WeatherDetailLoaded copyWith(
    bool favourite,
  ) {
    return WeatherDetailLoaded(location, weather, favourite);
  }
}

class WeatherDetailFailure extends WeatherDetailState {}
