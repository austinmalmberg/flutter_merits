import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_mode_provider.dart';

class MaintenanceTab extends StatelessWidget {
  const MaintenanceTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ThemeModeProvider themeMode = Provider.of<ThemeModeProvider>(context, listen: false);
              themeMode.toggle();
            },
            icon: Icon(Provider.of<ThemeModeProvider>(context).mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
    );
  }
}
