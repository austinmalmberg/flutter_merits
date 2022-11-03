import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_merits/src/screens/shared_components/ssn_mask.dart';
import 'package:provider/provider.dart';

import '../../data/person.dart';
import '../../services/person_service.dart';
import '../shared_components/employment_status_chip.dart';
import '_person_station_row.dart';

class PersonSelectDialog extends StatefulWidget {
  const PersonSelectDialog({super.key});

  @override
  State<PersonSelectDialog> createState() => _PersonSelectDialogState();
}

class _PersonSelectDialogState extends State<PersonSelectDialog> {
  List<Person>? _results = <Person>[];

  Future<void> _handlePerformSearch(String value) async {
    if (mounted) {
      setState(() => _results = null);
    }

    PersonService service = Provider.of<PersonService>(context, listen: false);
    List<Person> results = await service.fetchPersonsByLikeName(value);

    if (mounted) {
      setState(() => _results = results);
    }
  }

  void _popDialog(BuildContext context, [Person? person]) {
    Navigator.of(context).pop<Person?>(person);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Select a person for this licensure'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _SearchRow(onSubmit: _handlePerformSearch),
            ),

            Expanded(
              child: _results == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: _results!.length,
                      itemBuilder: (context, index) {
                        Person person = _results![index];

                        return ListTile(
                          onTap: () => _popDialog(context, person),
                          leading: Column(
                            children: [
                              EmploymentStatusChip(
                                status: person.status,
                                scale: 0.8,
                              ),
                            ],
                          ),
                          title: Text(
                            person.displayName(),
                            textScaleFactor: 1.4,
                          ),
                          subtitle: PersonStationRow(
                            area: person.area,
                            department: person.department,
                            tilePadding: const EdgeInsets.symmetric(vertical: 6.0),
                          ),
                          trailing: Column(
                            children: <Widget>[
                              MaskedSsnText(ssn: person.ssn),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Action button row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _popDialog(context),
                    child: const Text('CANCEL'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchRow extends StatefulWidget {
  final Function(String) onSubmit;

  const _SearchRow({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<_SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<_SearchRow> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _searchController,
            maxLines: 1,
            onSubmitted: widget.onSubmit,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => widget.onSubmit(_searchController.text),
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
