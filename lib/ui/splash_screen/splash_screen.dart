import 'package:book_store/ui/splash_screen/splash_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreenController screenController;
  @override
  Widget build(BuildContext context) {
    screenController= Get.find<SplashScreenController>();
    screenController.startSplashScreen();
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text("Welcome to Mr.Stein's Book Store",style: TextStyle(
              fontSize: 20,
              color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Pacifico'),),
        ),
      ),
    );
  }
}
