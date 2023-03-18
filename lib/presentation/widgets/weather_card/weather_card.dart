import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/models/location.dart';
import 'package:weather/presentation/widgets/weather_card/weather_card_cubit.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard(
      {super.key, required this.location, this.onTap, this.onLongPress});

  final Location location;
  final Function()? onTap;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCardCubit, WeatherCardState>(
        bloc: WeatherCardCubit(
          RepositoryProvider.of<WeatherService>(context),
          location,
        ),
        builder: (context, state) {
          if (state is WeatherCardLoaded) {
            return Card(
              color: AppColors.main,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 4,
                                child: Image(
                                  width: 200,
                                  height: 200,
                                  image: AssetImage(state.weather.image),
                                  fit: BoxFit.fitWidth,
                                )),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      location.name,
                                      style: const TextStyle(
                                        color: AppColors.textH1,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${state.weather.temperature.toStringAsFixed(1)}°',
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
                                      children: [
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.wind_power,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                '${state.weather.windSpeed} km/h',
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
                                            const Icon(
                                              Icons.arrow_upward,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 10),
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
                                            const Icon(
                                              Icons.arrow_downward,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 10),
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
                                )),
                          ],
                        ),
                      ]),
                ),
                onTap: onTap,
                onLongPress: onLongPress,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
