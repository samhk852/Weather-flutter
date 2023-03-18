import 'package:equatable/equatable.dart';
import 'package:weather/utilities/store.dart';

class Location extends Equatable implements Storable<Location> {
  const Location(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.elevation});

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double? elevation;

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      elevation: map['elevation'],
    );
  }

  @override
  List<Object?> get props => [id, name, latitude, longitude, elevation];

  @override
  String get docId => '$id';

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
    };
  }
}
