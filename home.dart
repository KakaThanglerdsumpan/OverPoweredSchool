import 'package:flutter/material.dart';
import 'pages/calc_page.dart';
import 'pages/home_page.dart';
import 'pages/schedule_page.dart';
import 'package:provider/provider.dart';

import 'services/theme_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.calculate_outlined), label: 'GPA Calc'),
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.schedule_rounded), label: 'Schedule')
  ];

  List<Widget> pages = const [CalcPage(), HomePage(), SchedulePage()];

  int _currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("OverPowered School"),
        leading: IconButton(
          onPressed: () {
            themeService.darkTheme = !themeService.darkTheme;
          },
          icon: Icon(themeService.darkTheme ? Icons.sunny : Icons.dark_mode),
        ),
      ),
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
