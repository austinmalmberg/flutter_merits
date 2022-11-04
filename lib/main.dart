import 'package:flutter/material.dart';
import 'package:flutter_merits/src/providers/licensure_provider.dart';
import 'package:flutter_merits/src/services/person_service.dart';
import 'package:provider/provider.dart';

import 'src/screens/home/main.dart';
import 'src/screens/licensure_details/main.dart';
import 'src/screens/routes.dart';
import 'src/services/licensure_service.dart';
import 'src/testing/test_licensure_service.dart';
import 'src/testing/test_person_service.dart';
import 'src/theme/theme_data.dart';
import 'src/theme/theme_mode_provider.dart';

void main() {
  final LicensureService licensureService = HttpTestLicensureService();
  const PersonService personService = LocalTestPersonService();

  final app = MeritsApp(
    licensureService: licensureService,
    personService: personService,
  );

  runApp(app);
}

class MeritsApp extends StatelessWidget {
  final LicensureService licensureService;
  final PersonService personService;

  const MeritsApp({super.key, required this.licensureService, required this.personService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Service Providers

        Provider<LicensureService>.value(value: licensureService),
        Provider<PersonService>.value(value: personService),

        // Data Providers

        ChangeNotifierProvider<ThemeModeProvider>(
          create: (context) => ThemeModeProvider(ThemeMode.dark),
        ),
        ChangeNotifierProxyProvider<LicensureService, LicensuresProvider>(
          create: (context) => LicensuresProvider(),
          update: (context, service, provider) => provider!
            ..setLicensureService(service)
            ..fetchOverviewList(),
          lazy: false,
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Merits',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeModeProvider>(context).mode,
        initialRoute: Routes.home,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.home:
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );

            case Routes.settings:
              throw UnimplementedError();

            case Routes.details:
              LicensureDetailsArguments? args = settings.arguments as LicensureDetailsArguments?;
              return MaterialPageRoute(
                builder: (context) => LicensureDetailsScreen(
                  summary: args?.summary,
                  index: args?.index,
                ),
              );

            default:
              throw UnimplementedError();
          }
        },
      ),
    );
  }
}
