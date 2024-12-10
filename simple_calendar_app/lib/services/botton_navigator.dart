import 'package:flutter/material.dart';
import '../screens/category_screen.dart';
import '../home_page.dart';

class BottomNavigator extends StatelessWidget {
  final int currentIndex;

  const BottomNavigator({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (currentIndex != index) {
          switch (index) {
            case 0:
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
              break;
            case 1:
              if (currentIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()),
                );
              }
              break;
            // case 2와 3은 추후 구현
          }
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
    );
  }
}
