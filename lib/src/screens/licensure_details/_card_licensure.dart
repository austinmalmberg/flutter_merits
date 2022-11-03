import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/licensure_details.dart';
import '../../data/licensure_status.dart';
import '../../data/licensure_type.dart';
import '../../theme/licensure_status.dart';
import '../../theme/licensure_type.dart';
import '_card_base.dart';
import '_licensure_type_icon.dart';
import '_licensure_type_select_dialog.dart';

class LicensureCardBuilder extends StatelessWidget {
  const LicensureCardBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    LicensureType? type = context.select<LicensureDetails, LicensureType?>((details) => details.licensureType);

    if (type == null) {
      return const _AddLicensureCard();
    }

    return _LicensureCard(details: Provider.of<LicensureDetails>(context, listen: false));
  }
}

class _AddLicensureCard extends StatelessWidget {
  const _AddLicensureCard({Key? key}) : super(key: key);

  Future<void> _handleLicensureTypeSelect(BuildContext context) async {
    LicensureDetails details = Provider.of<LicensureDetails>(context, listen: false);

    LicensureType? licensureType = await showDialog(
      context: context,
      builder: (context) => const LicensureTypeSelectDialog(),
    );

    if (details.licensureType != licensureType) {
      details.licensureType = licensureType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddDetailsButton(
      label: const Text('Add Licensure'),
      onPressed: () async => await _handleLicensureTypeSelect(context),
    );
  }
}

class _LicensureCard extends StatefulWidget {
  final LicensureDetails details;

  const _LicensureCard({Key? key, required this.details}) : super(key: key);

  @override
  State<_LicensureCard> createState() => _LicensureCardState();
}

class _LicensureCardState extends State<_LicensureCard> {
  late TextEditingController _listingNumberController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();

    _listingNumberController = TextEditingController(text: widget.details.listingNumber);
    _commentController = TextEditingController(text: widget.details.comment);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.details.licensureType == null) throw ArgumentError.notNull('details.licensureType');

    return LicensureDetailsCard.primary(
      header: ListTile(
        leading: FittedBox(child: LicensureTypeIcon(type: widget.details.licensureType!, size: 58.0)),
        title: Text(
          widget.details.licensureType.toString(),
          style: Theme.of(context).primaryTextTheme.headline5?.copyWith(
                color: getLicensureTypeColor(widget.details.licensureType!),
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Builder(builder: (context) {
          LicensureDetails details = Provider.of<LicensureDetails>(context);

          return Text(
            details.runtimeStatus.toString(),
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                ?.copyWith(color: getLicensureStatusColor(details.runtimeStatus)),
          );
        }),
        trailing: SizedBox(
          width: 140.0,
          child: TextFormField(
            controller: _listingNumberController,
            maxLines: 1,
            onChanged: (value) => Provider.of<LicensureDetails>(context, listen: false).listingNumber = value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4.0),
              label: Text('Listing #'),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const _LicensureDatesRow(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0).copyWith(bottom: 20.0),
            child: TextFormField(
              controller: _commentController,
              minLines: 4,
              maxLines: 12,
              onChanged: (value) => Provider.of<LicensureDetails>(context, listen: false).comment = value,
              decoration: const InputDecoration(
                label: Text('Comment'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LicensureDatesRow extends StatelessWidget {
  const _LicensureDatesRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Builder(builder: (context) {
            DateTime? issueDate = context.select<LicensureDetails, DateTime?>((details) => details.issueDate);
            return _DateCard(
              title: 'Issued',
              date: issueDate,
              onChanged: (value) {
                LicensureDetails details = Provider.of<LicensureDetails>(context, listen: false);
                details.issueDate = value;
              },
            );
          }),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              DateTime? expiration = context.select<LicensureDetails, DateTime?>((details) => details.expiration);

              return _DateCard(
                title: 'Expires',
                date: expiration,
                onChanged: (value) {
                  if (value != expiration) {
                    LicensureDetails details = Provider.of<LicensureDetails>(context, listen: false);

                    details.expiration = value;
                    details.status = value == null ? LicensureStatus.pending : LicensureStatus.active;
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({Key? key, required this.title, this.date, required this.onChanged}) : super(key: key);

  final String title;
  final DateTime? date;
  static final DateFormat formatter = DateFormat('MM/dd/yyyy');
  final Function(DateTime?) onChanged;

  Future<void> _onPressed(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.parse('2000-01-01'),
      lastDate: DateTime.parse('2099-12-31'),
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  Future<void> _onLongPress(BuildContext context) async {
    bool? clearDate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Date'),
        content: const Text('Do you really want to clear the date?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (clearDate == true) onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        ),
        onPressed: () => _onPressed(context),
        onLongPress: date == null ? null : () => _onLongPress(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).primaryTextTheme.headline6,
              ),
              const Divider(),
              Text(
                date == null ? '--/--/----' : formatter.format(date!),
                style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
                      fontSize: 20.0,
                      color: Theme.of(context).disabledColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
