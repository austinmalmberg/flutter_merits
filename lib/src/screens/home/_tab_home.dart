import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/licensure_summary.dart';
import '../../data/licensure_type.dart';
import '../../providers/licensure_provider.dart';
import '../../theme/theme_mode_provider.dart';
import '../routes.dart';
import '../shared_components/licensure_status_chip.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LicensuresProvider licensureProvider = Provider.of<LicensuresProvider>(context);
    List<LicensureSummary>? summaries = licensureProvider.licensures;

    if (summaries == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      primary: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ThemeModeProvider themeMode = Provider.of<ThemeModeProvider>(context, listen: false);
              themeMode.toggle();
            },
            icon: Icon(
                Provider.of<ThemeModeProvider>(context).mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          LicensuresProvider provider = Provider.of<LicensuresProvider>(context, listen: false);
          await provider.fetchOverviewList();
        },
        child: ListView.builder(
          itemCount: summaries.length,
          itemBuilder: (context, index) {
            LicensureSummary summary = summaries[index];

            return _LicensureSummaryListTile(
              summary: summary,
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.details,
                  arguments: LicensureDetailsArguments(summary: summary, index: index),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LicensureSummaryListTile extends StatelessWidget {
  final LicensureSummary summary;
  final Function()? onTap;

  const _LicensureSummaryListTile({
    Key? key,
    required this.summary,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (summary.licensureType == null) throw ArgumentError.notNull('summary.licensureType');

    return ListTile(
      minVerticalPadding: 6.0,
      onTap: onTap,
      leading: _LicensureTypeIcon(type: summary.licensureType!),
      title: Text(
        summary.person?.displayName() ?? '', // TODO: could need fixing
        textScaleFactor: 1.2,
      ),
      subtitle: summary.listingNumber.isEmpty
          ? const Text('')
          : Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(text: '# ', style: Theme.of(context).primaryTextTheme.subtitle1),
                  TextSpan(text: summary.listingNumber),
                ],
              ),
              style: Theme.of(context).primaryTextTheme.bodyText1,
            ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: LicensureStatusChip(
              status: summary.runtimeStatus,
              scale: 0.8,
            ),
          ),
          if (summary.expiration != null)
            _ExpirationWidgetBuilder(
              expiration: summary.expiration!,
              scale: 1.1,
            ),
        ],
      ),
    );
  }
}

class _ExpirationWidgetBuilder extends StatelessWidget {
  final DateTime expiration;
  final double scale;

  const _ExpirationWidgetBuilder({Key? key, required this.expiration, this.scale = 1.0}) : super(key: key);

  String _formatRemaining(Duration remaining) {
    String expiryString = '';

    int monthsOverdue = (remaining.inDays / 30).floor();

    if (monthsOverdue >= 3) {
      // only calculate months when overdue longer than 3 months
      expiryString += '${monthsOverdue}mo';
    } else if (monthsOverdue > 0) {
      // calculate months and days when overdue less than 3 months
      expiryString += '${monthsOverdue}mo';

      int daysOverdue = remaining.inDays % 30;
      if (daysOverdue > 0) expiryString += ' ${daysOverdue}d';
    } else {
      expiryString += ' ${remaining.inDays}d';
    }

    return '${expiryString.trim()} remaining';
  }

  String _formatOverdue(Duration overdue) {
    String expiryString = '';

    int monthsOverdue = (overdue.inDays / 30).floor();

    if (monthsOverdue >= 3) {
      // only calculate months when overdue longer than 3 months
      expiryString += '${monthsOverdue}mo';
    } else if (monthsOverdue > 0) {
      // calculate months and days when overdue less than 3 months
      expiryString += '${monthsOverdue}mo';

      int daysOverdue = overdue.inDays % 30;
      if (daysOverdue > 0) expiryString += ' ${daysOverdue}d';
    } else {
      expiryString += ' ${overdue.inDays}d';
    }

    return '(${expiryString.trim()} overdue)';
  }

  @override
  Widget build(BuildContext context) {
    Duration difference = expiration.difference(DateTime.now());

    String expirationText = difference.isNegative ? _formatOverdue(difference.abs()) : _formatRemaining(difference);

    return Text(
      expirationText,
      textScaleFactor: scale,
      style: difference.isNegative ? const TextStyle(color: Colors.red, fontWeight: FontWeight.w600) : null,
    );
  }
}

class _LicensureTypeIcon extends StatelessWidget {
  final LicensureType type;

  const _LicensureTypeIcon({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.primaries[LicensureType.values.indexOf(type) % Colors.primaries.length],
      ),
      child: Center(
        child: Text(type.name.toUpperCase()),
      ),
    );
  }
}
