import 'package:inventory_scanner/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key? key, // Make the Key nullable
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
          Icons.arrow_back_ios), // Use `const` for better performance
      color: Colors.black,
      onPressed: () {
        // If you want to navigate back to the previous screen
        Navigator.pop(context);
        // Navigate to CameraPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
        // If you specifically want to navigate to the SignInScreen
        // Navigator.pushNamed(context, SignInScreen.routeName);
      },
    );
  }
}
