import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/models/location.dart';
import 'package:weather/services/geocoding_service.dart';

part 'search_location_state.dart';

class SearchLocationCubit extends Cubit<SearchLocationState> {
  SearchLocationCubit(this._geocodingService) : super(SearchLocationInit()) {
    _init();
  }

  final GeocodingService _geocodingService;

  void queryChanged(String query) => _search(query);

  void _init() {}

  void _search(String query) {
    emit(SearchLocationLoading());
    _geocodingService
        .searchLocations(query)
        .then((locations) => emit(SearchLocationLoaded(locations)))
        .onError((error, stackTrace) => SearchLocationLoaded(const []));
  }
}
