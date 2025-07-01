import 'package:inventory_scanner/constants.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key, // Mark `key` as nullable since it's not required to be provided
    required this.text, // `required` keyword ensures `text` is initialized
    required this.image, // `required` keyword ensures `image` is initialized
  }) : super(key: key);

  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(), // Use `const` for better performance
        Text(
          "Scanify",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(25),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2), // Use `const` for better performance
        Image.asset(
          image,
          height: getProportionateScreenHeight(300),
          width: getProportionateScreenWidth(295),
        ),
      ],
    );
  }
}
