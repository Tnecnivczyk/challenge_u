import 'package:challenge_u/widgets/appWidgets/overview/statsForUserChallenge.dart';
import 'package:flutter/material.dart';

import '../../../classes/userChallengeU.dart';

class RankingListTile extends StatefulWidget {
  String pictureURL;
  UserChallengeU user;
  int rank;
  String challengeId;

  RankingListTile(this.pictureURL, this.user, this.rank, this.challengeId,
      {super.key});

  @override
  State<RankingListTile> createState() => _RankingListTileState();
}

class _RankingListTileState extends State<RankingListTile> {
  bool showStats = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 90,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                widget.rank.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 30,
              backgroundImage: NetworkImage(widget.pictureURL),
            ),
          ],
        ),
      ),
      title: Text(
        widget.user.username,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle:
          StatsForUserChallenge(showStats, widget.challengeId, widget.user),
      trailing: showStats
          ? IconButton(
              onPressed: () => setState(() {
                    showStats = !showStats;
                  }),
              icon: const Icon(Icons.arrow_drop_up))
          : IconButton(
              onPressed: () => setState(() {
                    showStats = !showStats;
                  }),
              icon: const Icon(Icons.arrow_drop_down)),
    );
  }
}
