import 'package:flutter/material.dart';
import 'package:i_am_rich/models.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int clicks = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<Stats>(
      builder: (context, stats, child) {
        void handleTap() {
          stats.tap();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${stats.money}\$",
                style: Theme.of(context).textTheme.headline1),
            GestureDetector(
              onTap: handleTap,
              child: const Image(
                image: AssetImage("images/diamond.png"),
              ),
            ),
          ],
        );
      },
    );
  }
}
