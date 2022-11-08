import 'package:flutter/material.dart';
import 'package:flutter_merits/src/utils/application_exception.dart';
import 'package:provider/provider.dart';

import '../../data/licensure_summary.dart';
import '../../data/licensure_details.dart';
import '../../providers/editing_controller.dart';
import '../../providers/licensure_provider.dart';
import '../../services/licensure_service.dart';
import '../../theme/licensure_type.dart';
import '_tab_activity.dart';
import '_tab_details.dart';

class LicensureDetailsScreen extends StatefulWidget {
  final LicensureSummary? summary;

  /// The index of the [summary] within the [LicensuresProvider]'s licensure list.
  ///
  /// If provided, the index will be updated if a new record is added or an existing record is modified.
  final int? index;

  const LicensureDetailsScreen({Key? key, this.summary, this.index}) : super(key: key);

  @override
  State<LicensureDetailsScreen> createState() => _LicensureDetailsScreenState();
}

class _LicensureDetailsScreenState extends State<LicensureDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);

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
                  : Text((snapshot.error! as ApplicationException).message),
            ),
          );
        }

        LicensureDetails details = snapshot.data!;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<LicensureDetails>.value(
              value: details,
            ),
            ChangeNotifierProvider<EditingController>(
              // Editing is enabled by default for new records
              create: (context) => EditingController(details.isNewRecord),
            ),
          ],
          builder: (context, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: details.licensureType == null ? null : getLicensureTypeColor(details.licensureType!),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Builder(
                    builder: (context) {
                      EditingController editingController = Provider.of<EditingController>(context);
                      LicensureDetails details = Provider.of<LicensureDetails>(context);

                      Color? appBarColor = details.licensureType == null
                          ? Theme.of(context).appBarTheme.backgroundColor
                          : getLicensureTypeColor(details.licensureType!);
                      Color textColor = _getContrastingColor(appBarColor);

                      if (editingController.isEditing) {
                        return TextButton.icon(
                          onPressed: () async => await _handleSaveRecordAndExit(context, details),
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                          style: TextButton.styleFrom(
                            foregroundColor: textColor,
                          ),
                        );
                      }

                      return TextButton.icon(
                        onPressed: () => editingController.isEditing = true,
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: textColor,
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

  Future<LicensureDetails> _getLicensureDetails(BuildContext context) async {
    if (widget.summary == null) {
      return LicensureDetails.newRecord();
    }

    LicensureService service = Provider.of<LicensureService>(context, listen: false);
    return await service.getLicensureDetailsById(widget.summary!.id);
  }

  Future<bool> _isExitDesired(BuildContext context, [LicensureDetails? details]) async {
    if (details == null || details.isNewRecord || !details.isModified) {
      // Exit if unchanged
      return true;
    }

    LicensuresProvider licensureProvider = Provider.of<LicensuresProvider>(context, listen: false);
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
    } on ServiceDataException catch (ex) {
      await _showSaveErrorDialog(ex);

      return false;
    }

    return true;
  }

  Future<void> _handleSaveRecordAndExit(BuildContext context, LicensureDetails details) async {
    LicensureService licensureService = Provider.of<LicensureService>(context, listen: false);
    LicensuresProvider licensureProvider = Provider.of<LicensuresProvider>(context, listen: false);

    NavigatorState navigator = Navigator.of(context);

    try {
      await _saveRecord(licensureService, details, licensureProvider);

      navigator.pop();
    } on ServiceDataException catch (ex) {
      // ScaffoldMessenger.maybeOf(context)
      //   ?..clearSnackBars()
      //   ..showSnackBar(
      //     SnackBar(
      //       content: Text(ex.message),
      //     ),
      //   );
      await _showSaveErrorDialog(ex);
    }
  }

  Future<void> _showSaveErrorDialog(ApplicationException ex) async {
    return await showDialog(
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

  /// Saves the [details], updates the id for new records, and resets its modification state.
  ///
  /// If [licensureProvider] is given, also updates the provider's list.
  ///
  /// Throws a [LicensureTypeRequiredException] when [details.licensureType] is null.
  /// Throws a [PersonRequiredException] when [details.person] is null.
  Future<bool> _saveRecord(LicensureService licensureService, LicensureDetails details,
      [LicensuresProvider? licensureProvider]) async {
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
