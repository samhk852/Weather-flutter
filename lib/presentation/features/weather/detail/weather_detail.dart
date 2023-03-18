import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/models/location.dart';
import 'package:weather/presentation/features/weather/detail/weather_detail_cubit.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/theme.dart';
import 'package:weather/utilities/store.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({super.key, required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => WeatherDetailCubit(
            RepositoryProvider.of<WeatherService>(context),
            RepositoryProvider.of<Store>(context),
            location),
        child: Scaffold(
          appBar: AppBar(
            actions: const [FavButton()],
          ),
          body: Container(
            color: AppColors.background,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const WeatherDetailPage(),
          ),
        ));
  }
}

class FavButton extends StatelessWidget {
  const FavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherDetailCubit, WeatherDetailState>(
        builder: ((context, state) {
      if (state is WeatherDetailLoaded) {
        final icon = state.favourite ? Icons.favorite : Icons.favorite_border;
        return IconButton(
            onPressed: () {
              BlocProvider.of<WeatherDetailCubit>(context).didTapFavourite();
            },
            icon: Icon(icon));
      }
      return const SizedBox.shrink();
    }));
  }
}

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherDetailCubit, WeatherDetailState>(
      builder: (context, state) {
        if (state is WeatherDetailLoaded) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Image(
                  width: 200,
                  height: 200,
                  image: AssetImage(state.weather.image),
                  fit: BoxFit.cover,
                ),
                Text(
                  state.location.name,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.textH1,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${state.weather.temperature}°',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.textH1,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  state.weather.desc,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.textH2,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                        ),
                        Text('${state.weather.windSpeed} km/h',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: AppColors.textH1,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        Text('${state.weather.maxTemp}°',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: AppColors.textH1,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                        Text('${state.weather.minTemp}°',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: AppColors.textH1,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
