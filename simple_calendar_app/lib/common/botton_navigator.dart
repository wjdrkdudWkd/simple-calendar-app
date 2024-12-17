import 'package:flutter/material.dart';
import 'package:simple_calendar_app/enum/navigation_screen.dart';

class BottomNavigator extends StatelessWidget {
  final NavigationScreen currentScreen;
  final ValueChanged<NavigationScreen> onScreenChanged;

  const BottomNavigator({
    super.key,
    required this.currentScreen,
    required this.onScreenChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentScreen.index,
      onTap: (index) {
        final selectedScreen = NavigationScreen.values[index];
        if (currentScreen != selectedScreen) {
          onScreenChanged(selectedScreen);
        }
      },
      items: NavigationScreen.values.map((screen) {
        return BottomNavigationBarItem(
          icon: Icon(screen.icon),
          label: screen.label,
        );
      }).toList(),
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
    );
  }
}
