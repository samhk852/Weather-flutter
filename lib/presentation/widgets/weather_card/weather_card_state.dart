part of 'weather_card_cubit.dart';

abstract class WeatherCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherCardInit extends WeatherCardState {}

class WeatherCardLoading extends WeatherCardState {}

class WeatherCardLoaded extends WeatherCardState {
  WeatherCardLoaded(this.weather);

  final Weather weather;

  @override
  List<Object?> get props => [weather];
}
