import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/UI/home_screen.dart';
import 'package:weather/UI/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
