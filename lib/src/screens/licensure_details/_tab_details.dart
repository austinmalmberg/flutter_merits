import 'package:flutter/material.dart';

import '_card_licensure.dart';
import '_card_person.dart';

class LicensureDetailsTab extends StatefulWidget {
  const LicensureDetailsTab({super.key});

  @override
  State<LicensureDetailsTab> createState() => _LicensureDetailsTabState();
}

class _LicensureDetailsTabState extends State<LicensureDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            const <Widget>[
              PersonCardBuilder(),
              LicensureCardBuilder(),
            ],
          ),
        ),
      ],
    );
  }
}
