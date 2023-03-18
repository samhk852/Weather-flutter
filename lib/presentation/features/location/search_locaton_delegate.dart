import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/features/location/search_location_cubit.dart';

class SearchLocationDelegate extends SearchDelegate {
  SearchLocationDelegate(this._bloc);

  final SearchLocationCubit _bloc;

  @override
  String? get searchFieldLabel => 'Search for cities';

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _bloc.queryChanged(query);
    return BlocBuilder<SearchLocationCubit, SearchLocationState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is SearchLocationLoaded) {
            if (state.locations.isEmpty) {
              return const Center(child: Text('No Results'));
            }
            final locations = state.locations.map((e) => e.name);
            return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    state.locations[index].name,
                  ),
                  subtitle: Text(
                      'Latitude: ${state.locations[index].latitude}, Latitude: ${state.locations[index].latitude}: ${state.locations[index].longitude}'),
                  onTap: () {
                    close(context, state.locations[index]);
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
