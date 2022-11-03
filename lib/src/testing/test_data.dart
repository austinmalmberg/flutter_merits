import '../data/activity_entry.dart';
import '../data/licensure_status.dart';
import '../data/licensure_summary.dart';
import '../data/licensure_details.dart';
import '../data/licensure_type.dart';
import '../data/person.dart';

Person samplePerson = Person(
  firstName: 'Austin',
  lastName: 'Malmberg',
  status: EmploymentStatus.active,
  ssn: '1234',
  area: 'ISS or a really long area name that will not fit within the TextTile',
  department: 'App Team',
  title: 'Applications Technician I',
);

LicensureSummary sampleSummary = LicensureSummary(
  id: 1,
  licensureType: LicensureType.cna,
  status: LicensureStatus.active,
  person: samplePerson,
  listingNumber: '1231515134',
  expiration: DateTime.parse('2022-12-31'),
  lastVerified: DateTime.now(),
);

List<LicensureSummary> licensureSummaries = <LicensureSummary>[
  sampleSummary,
  LicensureSummary(
    id: 2,
    licensureType: LicensureType.lpn,
    status: LicensureStatus.pending,
    person: samplePerson,
    lastVerified: DateTime.now(),
  ),
  LicensureSummary(
    id: 3,
    licensureType: LicensureType.rn,
    status: LicensureStatus.active,
    person: samplePerson,
    listingNumber: '131515134',
    expiration: DateTime.parse('2022-06-31'),
    lastVerified: DateTime.now(),
  ),
];

LicensureDetails sampleDetails = fromSummary(sampleSummary);

LicensureDetails fromSummary(LicensureSummary summary) => LicensureDetails.fromSummary(
      summary,
      comments: 'This is a sample comment',
      issueDate:
          summary.status == LicensureStatus.pending ? null : DateTime.now().subtract(const Duration(days: 4 * 30)),
      activityLog: <ActivityEntry>[
        ActivityEntry(
            timestamp: DateTime.now().subtract(const Duration(days: 4)), creator: samplePerson, comment: 'Verified'),
      ],
    );
