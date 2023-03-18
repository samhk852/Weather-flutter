part of 'search_location_cubit.dart';

abstract class SearchLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchLocationInit extends SearchLocationState {}

class SearchLocationLoading extends SearchLocationState {}

class SearchLocationLoaded extends SearchLocationState {
  SearchLocationLoaded(this.locations);

  final List<Location> locations;

  @override
  List<Object?> get props => [locations];
}
