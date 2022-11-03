import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/licensure_summary.dart';
import '../../data/licensure_details.dart';
import '../../providers/licensure_provider.dart';
import '../../services/licensure_service.dart';
import '../../theme/licensure_type.dart';
import '_tab_activity.dart';
import '_tab_details.dart';

class LicensureDetailsScreen extends StatefulWidget {
  final LicensureSummary? summary;

  /// The index of the [summary] within the [LicensureProvider]'s licensure list.
  ///
  /// If provided, the index will be updated if a new record is added or an existing record is modified.
  final int? index;

  const LicensureDetailsScreen({Key? key, this.summary, this.index}) : super(key: key);

  @override
  State<LicensureDetailsScreen> createState() => _LicensureDetailsScreenState();
}

class _LicensureDetailsScreenState extends State<LicensureDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> _isExitDesired(BuildContext context, [LicensureDetails? details]) async {
    if (details == null || details.isNewRecord || !details.isModified) {
      // Exit if unchanged
      return true;
    }

    LicensureProvider licensureProvider = Provider.of<LicensureProvider>(context, listen: false);
    LicensureService licensureService = Provider.of<LicensureService>(context, listen: false);

    bool? saveChanges = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Changes'),
        content: const Text('Do you want to save changes?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('NO'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (saveChanges == null) {
      // Dialog cancelled
      return false;
    } else if (!saveChanges) {
      // Dialog option NO selected
      return true;
    }

    try {
      await _saveRecord(licensureService, details, licensureProvider);
    } on DataException catch (ex) {
      await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(ex.message),
        ),
      );

      return false;
    }

    return true;
  }

  /// Saves the [details], updates the id for new records, and resets its modification state.
  ///
  /// If [licensureProvider] is given, also updates the provider's list.
  ///
  /// Throws a [LicensureTypeRequiredException] when [details.licensureType] is null.
  /// Throws a [PersonRequiredException] when [details.person] is null.
  Future<bool> _saveRecord(LicensureService licensureService, LicensureDetails details,
      [LicensureProvider? licensureProvider]) async {
    // TODO: save to db
    bool savedToDatabase = await licensureService.saveLicensureDetails(details);

    if (!savedToDatabase || licensureProvider == null) return savedToDatabase;

    // Update the list without fetching the licensures again
    if (widget.index == null) {
      licensureProvider.add(details);
    } else {
      licensureProvider.update(widget.index!, details);
    }

    return savedToDatabase;
  }

  Future<void> _handleSaveRecordAndExit(BuildContext context, LicensureDetails details) async {
    LicensureService licensureService = Provider.of<LicensureService>(context, listen: false);
    LicensureProvider licensureProvider = Provider.of<LicensureProvider>(context, listen: false);

    NavigatorState navigator = Navigator.of(context);

    try {
      await _saveRecord(licensureService, details, licensureProvider);

      navigator.pop();
    } on DataException catch (ex) {
      await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Save Error'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ex.message),
                ],
              ),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<LicensureDetails> _getLicensureDetails(BuildContext context) async {
    if (widget.summary == null) {
      return LicensureDetails.newRecord();
    }

    LicensureService service = Provider.of<LicensureService>(context, listen: false);
    return await service.getLicensureDetailsById(widget.summary!.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LicensureDetails>(
      future: _getLicensureDetails(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: snapshot.connectionState != ConnectionState.done
                  ? const CircularProgressIndicator()
                  : Text(snapshot.error!.toString()),
            ),
          );
        }

        LicensureDetails details = snapshot.data!;

        return ChangeNotifierProvider<LicensureDetails>.value(
          value: details,
          builder: (context, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: details.licensureType == null ? null : getLicensureTypeColor(details.licensureType!),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Builder(
                    builder: (context) {
                      LicensureDetails details = Provider.of<LicensureDetails>(context);
                      Color? appBarColor = details.licensureType == null
                          ? Theme.of(context).appBarTheme.backgroundColor
                          : getLicensureTypeColor(details.licensureType!);

                      return TextButton.icon(
                        onPressed: details.isModified || details.isNewRecord
                            ? () => _handleSaveRecordAndExit(context, details)
                            : null,
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        style: TextButton.styleFrom(
                          foregroundColor: _getContrastingColor(appBarColor),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              onWillPop: () async => await _isExitDesired(context, details),
              child: _LicensureDetailsPage(details: details),
            ),
          ),
        );
      },
    );
  }
}

class _LicensureDetailsPage extends StatefulWidget {
  final LicensureDetails details;

  const _LicensureDetailsPage({Key? key, required this.details}) : super(key: key);

  @override
  State<_LicensureDetailsPage> createState() => _LicensureDetailsPageState();
}

class _LicensureDetailsPageState extends State<_LicensureDetailsPage> {
  int _tabIndex = 0;

  static const int detailsIndex = 0;
  static const int activityIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: _showTab(_tabIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (value) => setState(() => _tabIndex = value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Activity',
          ),
        ],
      ),
    );
  }

  Widget _showTab(int tabIndex) {
    switch (tabIndex) {
      case detailsIndex:
        return const LicensureDetailsTab();
      case activityIndex:
        return LicensureActivityTab(activityLog: widget.details.activityLog);
      default:
        throw UnimplementedError();
    }
  }
}

/// Returns [Colors.white] if [color] is dark and [Colors.black] otherwise.
Color _getContrastingColor(Color? color, {Color defaultColor = Colors.white}) {
  if (color == null) return defaultColor;

  int colorTotal = color.red + color.green + color.blue;
  int max = 255 * 3;
  double half = max / 2;
  if (colorTotal < half) {
    // color will be dark
    return Colors.white;
  }

  return Colors.black;
}
