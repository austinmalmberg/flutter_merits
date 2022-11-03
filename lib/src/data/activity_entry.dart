import 'person.dart';

class ActivityEntry {
  final DateTime timestamp;
  final Person creator;
  final String comment;

  ActivityEntry({required this.timestamp, required this.creator, required this.comment});
}
