import 'package:inventory_scanner/constants.dart';
import 'package:inventory_scanner/size_config.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key, // Make the Key nullable
    required this.text, // Use required to ensure text is provided
    required this.press, // Use required to ensure press callback is provided
  }) : super(key: key);

  final String text;
  final VoidCallback press; // Use VoidCallback for clarity and specificity

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized at the start of build if it's not already done elsewhere
    SizeConfig().init(context);

    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // Text Color
          backgroundColor: kPrimaryColor, // Background Color
          padding: EdgeInsets.all(getProportionateScreenWidth(15)), // Padding
        ),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white, // Text color
          ),
        ),
      ),
    );
  }
}
