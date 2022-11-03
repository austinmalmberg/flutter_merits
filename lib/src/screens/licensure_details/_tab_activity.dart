import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/activity_entry.dart';

class LicensureActivityTab extends StatelessWidget {
  final List<ActivityEntry> activityLog;
  static final DateFormat _formatter = DateFormat.yMd().add_jm();

  const LicensureActivityTab({super.key, required this.activityLog});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        ActivityEntry entry = activityLog[index];

        return ListTile(
          leading: Text(entry.creator.displayName()),
          title: Text(entry.comment),
          subtitle: Text(_formatter.format(entry.timestamp)),
        );
      },
      itemCount: activityLog.length,
    );
  }
}
