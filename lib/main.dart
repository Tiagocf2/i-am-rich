import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_rich/home.dart';
import 'package:i_am_rich/models.dart';
import 'package:i_am_rich/shop.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xFF282828)));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stats stats;

  @override
  void initState() {
    //Load saved stats
    stats = Stats();
    stats.addItems([
      Tap(),
      Clicker(),
      Farm(),
    ]);

    super.initState();
  }

  final pageController = PageController(keepPage: true);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.lightBlue.shade100,
          onPrimary: const Color(0xFF383344),
          secondary: Colors.deepOrange.shade300,
          onSecondary: Colors.white,
          error: Colors.red.shade400,
          onError: Colors.white,
          background: const Color(0xFF191919),
          onBackground: Colors.white,
          surface: const Color(0xFF555555),
          onSurface: Colors.white,
          shadow: Colors.white24,
        ),
        backgroundColor: const Color(0xFF191919),

        // fontFamily: 'Arial',
        textTheme: const TextTheme(
            button: TextStyle(fontSize: 18),
            headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
            headline2: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white24),
            headline3: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF222222),
        // appBar: AppBar(
        //   toolbarOpacity: 0.8,
        //   elevation: 50,
        //   title: const Center(child: Text('I am Rich')),
        //   backgroundColor: const Color(0xFF282828),
        // ),
        body: ChangeNotifierProvider(
          create: (context) => stats,
          child: SafeArea(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomeScreen(),
                Shop(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
            pageController.jumpToPage(value);
          },
          backgroundColor: const Color(0xFF191919),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white10,
          currentIndex: currentIndex,
          iconSize: 42,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const Icon(Icons.diamond_rounded)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const Icon(Icons.shop_rounded)),
              label: 'Shop',
            ),
          ],
        ),
      ),
    );
  }
}
