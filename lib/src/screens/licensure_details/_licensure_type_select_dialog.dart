import 'package:flutter/material.dart';
import 'package:flutter_merits/src/screens/licensure_details/_licensure_type_icon.dart';

import '../../data/licensure_type.dart';

class LicensureTypeSelectDialog extends StatefulWidget {
  const LicensureTypeSelectDialog({super.key});

  @override
  State<LicensureTypeSelectDialog> createState() => _LicensureTypeSelectDialogState();
}

class _LicensureTypeSelectDialogState extends State<LicensureTypeSelectDialog> {
  void _popDialog(BuildContext context, [LicensureType? person]) {
    Navigator.of(context).pop<LicensureType?>(person);
  }

  @override
  Widget build(BuildContext context) {
    List<LicensureType> licensureTypes = LicensureType.values.toList();
    licensureTypes.sort((a, b) => a.toString().compareTo(b.toString()));

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: licensureTypes.length,
            itemBuilder: (context, index) {
              LicensureType type = licensureTypes[index];

              return ListTile(
                minVerticalPadding: 20.0,
                onTap: () => _popDialog(context, type),
                leading: FittedBox(
                  child: LicensureTypeIcon(type: type, size: 58.0),
                ),
                title: Text(
                  type.toString(),
                  textScaleFactor: 1.4,
                ),
              );
            },
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
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
      ),
    );
  }
}
