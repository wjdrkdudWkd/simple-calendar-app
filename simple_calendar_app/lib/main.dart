import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_calendar_app/common/main_layout.dart';
import 'package:simple_calendar_app/providers/category_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 데스크톱 환경 초기화
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await AppDatabase.instance.database; // SQLite 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = CategoryProvider();
        // 앱 시작 시 카테고리 로드
        provider.loadCategories();
        return provider;
      },
      child: MaterialApp(
        title: 'Calendar App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: const Color(0xFF1A1B1E),
          // scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            // backgroundColor: Colors.teal,
            backgroundColor: Color(0xFF1A1B1E),
            // backgroundColor: Colors.white,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            // backgroundColor: Colors.teal,
            backgroundColor: Colors.pink,
          ),
        ),
        home: const MainLayout(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
