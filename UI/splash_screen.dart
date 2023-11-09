import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/UI/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotlogin();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(243, 224, 226, 225),
      body: Center(
        child: Image.asset(
          "images/weather-app.png",
          height: 140,
          width: 140,
        ),
      ),
    );
  }

  Future<void> gotlogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(const HomeScreen());
  }
}
