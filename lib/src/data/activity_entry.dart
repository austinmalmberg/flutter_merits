import 'person.dart';

class ActivityEntry {
  final DateTime timestamp;
  final Person creator;
  final String comment;

  ActivityEntry({required this.timestamp, required this.creator, required this.comment});

  factory ActivityEntry.fromJson(Map<String, dynamic> json) => ActivityEntry(
        timestamp: DateTime.parse(json['timestamp']),
        creator: Person.fromJson(json['creator'] as Map<String, dynamic>),
        comment: json['comment'] ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'timestamp': timestamp,
        'creator': creator,
        'comment': comment,
      };
}
