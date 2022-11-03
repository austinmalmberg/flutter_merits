import 'package:flutter/material.dart';
import 'package:flutter_merits/src/screens/shared_components/ssn_mask.dart';
import 'package:provider/provider.dart';

import '../../data/licensure_details.dart';
import '../../data/person.dart';
import '../../theme/employment_status.dart';
import '../../theme/theme_data.dart';
import '_card_base.dart';
import '_data_tile.dart';
import '_person_select_dialog.dart';
import '_person_station_row.dart';

class PersonCardBuilder extends StatelessWidget {
  const PersonCardBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    Person? person = context.select<LicensureDetails, Person?>((details) => details.person);

    if (person == null) {
      return const _AddPersonCard();
    }

    return _PersonCard(person: person);
  }
}

class _PersonCard extends StatelessWidget {
  final Person person;

  const _PersonCard({
    Key? key,
    required this.person,
  }) : super(key: key);

  final EdgeInsets _tilePadding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0);

  @override
  Widget build(BuildContext context) {
    final TextStyle? tileTextStyle = Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
          fontSize: 20.0,
          color: Theme.of(context).disabledColor,
        );

    return LicensureDetailsCard.primary(
      header: ListTile(
        leading: FittedBox(
          child: Icon(
            Icons.person,
            size: 58.0,
            color: getEmploymentStatusColor(person.status),
            shadows: iconShadows(context),
          ),
        ),
        title: Text(
          person.displayName(),
          style: Theme.of(context).primaryTextTheme.headline5,
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
      label: const Text('Add Person'),
    );
  }
}
