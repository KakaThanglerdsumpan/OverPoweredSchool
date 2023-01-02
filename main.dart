import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'services/local_storage_service.dart';
import 'view_models/budget_view_model.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorageService = LocalStorageService();
  await localStorageService.initializeHive();
  final sharedPreferences = await SharedPreferences.getInstance();
  return runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({required this.sharedPreferences, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(sharedPreferences)),
        ChangeNotifierProvider<BudgetViewModel>(
            create: (_) => BudgetViewModel()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeService = Provider.of<ThemeService>(context);
          return MaterialApp(
              title: 'OverPowered School',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    brightness: themeService.darkTheme
                        ? Brightness.dark
                        : Brightness.light,
                    seedColor: Colors.indigo),
              ),
              home: const Home());
        },
      ),
    );
  }
}
