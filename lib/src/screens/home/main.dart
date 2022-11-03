import 'package:flutter/material.dart';

import '../routes.dart';
import '_tab_maintenance.dart';
import '_tab_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int overviewIndex = 0;
  static const int maintenanceIndex = 1;

  int _tabIndex = 0;

  Widget _activeTabWidget() {
    switch (_tabIndex) {
      case overviewIndex:
        return const HomeTab();
      case maintenanceIndex:
        return const MaintenanceTab();
      default:
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _activeTabWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (value) => setState(() => _tabIndex = value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Maintenance',
          ),
        ],
      ),
      floatingActionButton: _tabIndex == overviewIndex
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.details);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
