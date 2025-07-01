import 'package:inventory_scanner/constants.dart';
import 'package:inventory_scanner/size_config.dart';
import 'package:flutter/material.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key, // Make the Key nullable
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized at the start of build if it's not already done elsewhere
    SizeConfig().init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the SignUp screen
            Navigator.pushNamed(context,
                'SignUpScreenRoute'); // Replace with your actual route name
          },
          child: Text(
            "SignUp",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
