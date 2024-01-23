import 'package:flutter/material.dart';
import 'package:gsoc/main.dart';
import 'package:gsoc/start.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Start(),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 3,
            ),
            Text("FocusFinder", style: TextStyle(fontSize: 30)),
            SizedBox(
              height: 10,
            ),
            Spacer(
              flex: 2,
            ),
            Text("Take-home qualification tasks",
                style: TextStyle(fontSize: 15)),
            Text("Afjal",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
