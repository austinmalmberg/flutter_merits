import 'package:flutter/material.dart';
import 'package:flutter_merits/src/providers/card_animation_provider.dart';
import 'package:provider/provider.dart';

import '_card_licensure.dart';
import '_card_person.dart';

class LicensureDetailsTab extends StatelessWidget {
  const LicensureDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CardAnimationProvider>(
      create: (context) => CardAnimationProvider(
        translateDuration: const Duration(milliseconds: 600),
        scaleDuration: const Duration(milliseconds: 400),
      ),
      builder: (context, child) => CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const PersonCardBuilder(staggerFraction: 0 / 1),
                const LicensureCardBuilder(staggerFraction: 1 / 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
