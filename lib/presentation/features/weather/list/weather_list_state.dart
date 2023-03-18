part of 'weather_list_cubit.dart';

abstract class WeatherListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherListInit extends WeatherListState {}

class WeatherListLoaded extends WeatherListState {
  WeatherListLoaded(this.locations);

  final List<Location> locations;

  @override
  List<Object?> get props => [locations];
}
