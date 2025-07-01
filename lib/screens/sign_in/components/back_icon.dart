import 'package:inventory_scanner/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key? key, // Make the Key parameter nullable
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
          Icons.arrow_back_ios), // Added `const` for better performance
      color: Colors.black,
      onPressed: () {
        // Consider using Navigator.pop if you want to go back to the previous screen
        Navigator.pushNamed(context, SplashScreen.routeName);
      },
    );
  }
}
