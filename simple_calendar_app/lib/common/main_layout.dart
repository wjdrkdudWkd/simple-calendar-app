import 'package:flutter/material.dart';
import 'package:simple_calendar_app/common/botton_navigator.dart';
import 'package:simple_calendar_app/enum/navigation_screen.dart';
import 'package:simple_calendar_app/screens/category_screen.dart';
import 'package:simple_calendar_app/home_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  NavigationScreen _currentScreen = NavigationScreen.today;

  final Map<NavigationScreen, Widget> _screens = {
    NavigationScreen.today: const HomePage(),
    NavigationScreen.schedule: const CategoryScreen(),
    NavigationScreen.tasks: const Placeholder(),
    NavigationScreen.profile: const Placeholder(),
  };

  void onScreenChanged(NavigationScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentScreen.index,
        children: _screens.values.toList(),
      ),
      bottomNavigationBar: BottomNavigator(
        currentScreen: _currentScreen,
        onScreenChanged: onScreenChanged,
      ),
    );
  }
}
