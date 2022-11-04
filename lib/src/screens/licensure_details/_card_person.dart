import 'package:flutter/material.dart';
import 'package:flutter_merits/src/providers/card_animation_provider.dart';
import 'package:flutter_merits/src/screens/shared_components/ssn_mask.dart';
import 'package:provider/provider.dart';

import '../../data/licensure_details.dart';
import '../../data/person.dart';
import '../../theme/employment_status.dart';
import '../../theme/theme_data.dart';
import '_card_animations.dart';
import '_card_base.dart';
import '_data_tile.dart';
import '_person_select_dialog.dart';
import '_person_station_row.dart';

class PersonCardBuilder extends StatelessWidget {
  final double staggerFraction;

  const PersonCardBuilder({super.key, this.staggerFraction = 0.0});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    CardAnimationProvider animationProvider = Provider.of<CardAnimationProvider>(context);

    Person? person = context.select<LicensureDetails, Person?>((details) => details.person);

    if (person == null) {
      return GrowAnimation(
        duration: animationProvider.scaleDuration,
        scaleBuilder: (controller) => animationProvider.staggeredScaleAnimationBuilder(controller, staggerFraction),
        child: const _AddPersonCard(),
      );
    }

    return SlideAnimation(
      duration: animationProvider.translateDuration,
      slideBuilder: (controller) =>
          animationProvider.staggeredTranslateAnimationBuilder(controller, width, staggerFraction),
      child: _PersonCard(person: person, staggerFraction: staggerFraction),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Person person;
  final double staggerFraction;

  const _PersonCard({Key? key, required this.person, required this.staggerFraction}) : super(key: key);

  final EdgeInsets _tilePadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0);

  @override
  Widget build(BuildContext context) {
    final TextStyle? tileTextStyle = Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
          fontSize: 20.0,
          color: Theme.of(context).disabledColor,
        );

    return LicensureDetailsCard(
      header: ListTile(
        leading: FittedBox(
          child: Icon(
            Icons.person,
            size: 58.0,
            color: getEmploymentStatusColor(person.status),
            shadows: iconShadows(context),
          ),
        ),
        title: Row(
          children: [
            Text(
              person.displayName(),
              style: Theme.of(context).primaryTextTheme.headline5,
            ),
            if (Provider.of<LicensureDetails>(context, listen: false).isNewRecord)
              IconButton(
                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                onPressed: () {
                  Provider.of<LicensureDetails>(context, listen: false).person = null;
                },
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        trailing: MaskedSsnText(
          ssn: person.ssn,
        ),
      ),
      body: Column(
        children: [
          PersonStationRow(
            area: person.area,
            department: person.department,
            tilePadding: _tilePadding,
            textStyle: tileTextStyle,
          ),
          TextTile(
            label: 'Title',
            iconData: Icons.business_center,
            value: person.title,
            tilePadding: _tilePadding,
            textStyle: tileTextStyle,
          ),
        ],
      ),
    );
  }
}

class _AddPersonCard extends StatelessWidget {
  const _AddPersonCard({Key? key}) : super(key: key);

  Future<void> _handlePersonSelect(BuildContext context) async {
    LicensureDetails details = Provider.of<LicensureDetails?>(context, listen: false)!;

    Person? person = await showDialog(
      context: context,
      builder: (context) => const PersonSelectDialog(),
    );

    if (details.person != person) {
      details.person = person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddDetailsButton(
      onPressed: () async => await _handlePersonSelect(context),
      label: const Text('Person'),
    );
  }
}
