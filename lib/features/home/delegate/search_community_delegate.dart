import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loading_widget.dart';
import '../../community/controller/community_controller.dart';

class SearchCommunityDelegate extends SearchDelegate {

  final WidgetRef ref;

  SearchCommunityDelegate({required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = '';

        }, 
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    void navigateToCommunity(BuildContext context, String name) {
      Routemaster.of(context).push('r/$name');
    }

    return ref.watch(searchCommunityProvider(query)).when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data[index].avatar),
          ),
          title: Text('r/${data[index].name}'),
          onTap: () => navigateToCommunity(context, data[index].name),
        )
      ), 
      error: (error, stackTrade) => ErrorText(message: error.toString()), 
      loading: () => const LoadingWidget(),
    );
  }
}