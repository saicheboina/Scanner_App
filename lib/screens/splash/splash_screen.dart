import 'package:inventory_scanner/screens/splash/Components/body.dart';
import 'package:inventory_scanner/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // We have to call it in our startig screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
