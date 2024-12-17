import 'package:flutter/material.dart';

enum NavigationScreen {
  today,
  schedule,
  tasks,
  profile;

  String get label {
    switch (this) {
      case NavigationScreen.today:
        return 'Today';
      case NavigationScreen.schedule:
        return 'Schedule';
      case NavigationScreen.tasks:
        return 'Tasks';
      case NavigationScreen.profile:
        return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationScreen.today:
        return Icons.calendar_today;
      case NavigationScreen.schedule:
        return Icons.schedule;
      case NavigationScreen.tasks:
        return Icons.task;
      case NavigationScreen.profile:
        return Icons.person;
    }
  }
}
