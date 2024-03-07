import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communiverse/services/community_service.dart';
import 'package:communiverse/models/community.dart';

class MyCommunitiesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final communityService = Provider.of<CommunityService>(context);
    final myCommunities = communityService.myCommunities;

    // Dividir la lista de comunidades en sublistas de dos elementos
    List<List<Community>> communityPairs = [];
    for (int i = 0; i < myCommunities.length; i += 2) {
      int end = i + 2 < myCommunities.length ? i + 2 : myCommunities.length;
      communityPairs.add(myCommunities.sublist(i, end));
    }

    return ListView.builder(
      itemCount: communityPairs.length,
      itemBuilder: (context, index) {
        final communities = communityPairs[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: communities.map((community) {
            return CommunityCard(community: community);
          }).toList(),
        );
      },
    );
  }
}
