import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/models/location.dart';
import 'package:weather/utilities/store.dart';
import 'package:geolocator/geolocator.dart';

part 'weather_list_state.dart';

class WeatherListCubit extends Cubit<WeatherListState> {
  WeatherListCubit(this._store) : super(WeatherListInit()) {
    _init();
  }

  final Store _store;

  void didTapLocate() => _locate();
  void didDelete(int index) => _delete(index);

  void _init() {
    _loadLocations(defaultLocation: true);
    _observe();
  }

  void _loadLocations({bool defaultLocation = false}) async {
    final collection = await _store.getList(StoreCollection.favourite);
    if (collection != null) {
      final locations =
          collection.values.map((doc) => Location.fromMap(doc)).toList();
      emit(WeatherListLoaded(locations));
    } else {
      // Default Location
      const location = Location(
          id: 1819730,
          name: 'Hong Kong',
          latitude: 22.25,
          longitude: 114.16667,
          elevation: 46);
      emit(WeatherListLoaded(const [location]));
    }
  }

  void _observe() async {
    _store.stream().listen((collection) {
      if (collection == StoreCollection.favourite) {
        _loadLocations();
      }
    });
  }

  void _locate() async {
    final position = await _determinePosition();
    if (state is WeatherListLoaded) {
      if ((state as WeatherListLoaded).locations.first.id != 1) {
        _store.save(
            StoreCollection.favourite,
            Location(
                id: -1,
                name: 'Current Location',
                latitude: position.latitude,
                longitude: position.longitude));
      }
    }
  }

  void _delete(int id) {
    if (state is WeatherListLoaded) {
      _store.delete(StoreCollection.favourite, '$id');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
