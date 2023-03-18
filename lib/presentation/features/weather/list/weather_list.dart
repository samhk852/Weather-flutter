import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/main.dart';
import 'package:weather/presentation/features/location/search_location_cubit.dart';
import 'package:weather/presentation/features/location/search_locaton_delegate.dart';
import 'package:weather/presentation/features/weather/list/weather_list_cubit.dart';
import 'package:weather/presentation/widgets/weather_card/weather_card.dart';
import 'package:weather/services/geocoding_service.dart';
import 'package:weather/theme.dart';
import 'package:weather/utilities/store.dart';

class WeatherListScreen extends StatelessWidget {
  const WeatherListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        leading: IconButton(
            onPressed: () async {
              BlocProvider.of<WeatherListCubit>(context).didTapLocate();
            },
            icon: const Icon(Icons.gps_fixed)),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchLocationDelegate(
                    SearchLocationCubit(
                      RepositoryProvider.of<GeocodingService>(context),
                    ),
                  ),
                ).then((location) {
                  if (location != null) {
                    Navigator.pushNamed(context, AppRoutes.detail,
                        arguments: location);
                  }
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            WeatherListCubit(RepositoryProvider.of<Store>(context)),
        child: Container(
          color: AppColors.background,
          child: const WeatherListPage(),
        ),
      ),
    );
  }
}

class WeatherListPage extends StatelessWidget {
  const WeatherListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherListCubit, WeatherListState>(
      builder: (context, state) {
        if (state is WeatherListLoaded) {
          return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.locations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: WeatherCard(
                    location: state.locations[index],
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.detail,
                          arguments: state.locations[index]);
                    },
                    onLongPress: () {
                      showAlertDialog(context).then((confirmed) {
                        if (confirmed != null && confirmed) {
                          BlocProvider.of<WeatherListCubit>(context)
                              .didDelete(state.locations[index].id);
                        }
                      });
                    },
                  ),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<T?> showAlertDialog<T>(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete?'),
            content: const Text('Are you sure you want to delete this item?'),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Delete',
                  )),
            ],
          );
        });
  }
}
