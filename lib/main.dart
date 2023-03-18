import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/models/location.dart';
import 'package:weather/presentation/features/weather/detail/weather_detail_cubit.dart';
import 'package:weather/presentation/features/weather/list/weather_list.dart';
import 'package:weather/presentation/features/weather/list/weather_list_cubit.dart';
import 'package:weather/services/geocoding_service.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/utilities/store.dart';
import 'presentation/features/weather/detail/weather_detail.dart';
import 'services/open_meteo_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appStore = AppStore();
  final appService = OpenMeteoService(appStore);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WeatherService>(
          create: (context) => appService,
        ),
        RepositoryProvider<GeocodingService>(
          create: (context) => appService,
        ),
        RepositoryProvider<Store>(
          create: (context) => appStore,
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      routes: _routes(),
    );
  }
}

class AppRoutes {
  static const list = '/';
  static const detail = 'detail';
}

Map<String, WidgetBuilder> _routes() {
  return <String, WidgetBuilder>{
    AppRoutes.list: (context) => _weatherListBloc(),
    AppRoutes.detail: (context) =>
        _weatherDetailBloc(ModalRoute.of(context)?.settings.arguments),
  };
}

BlocProvider<WeatherListCubit> _weatherListBloc() {
  return BlocProvider<WeatherListCubit>(
    create: (context) =>
        WeatherListCubit(RepositoryProvider.of<Store>(context)),
    child: const WeatherListScreen(),
  );
}

BlocProvider<WeatherDetailCubit> _weatherDetailBloc(Object? location) {
  return BlocProvider<WeatherDetailCubit>(
    create: (context) => WeatherDetailCubit(
        RepositoryProvider.of<WeatherService>(context),
        RepositoryProvider.of<Store>(context),
        location),
    child: WeatherDetailScreen(
      location: location as Location,
    ),
  );
}
