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
        'timestamp': timestamp.toIso8601String(),
        'creator': creator.toJson(),
        'comment': comment,
      };

  @override
  bool operator ==(Object other) {
    if (other is! ActivityEntry) return false;

    return timestamp == other.timestamp && creator == other.creator && comment == other.comment;
  }

  @override
  int get hashCode => super.hashCode;
}
