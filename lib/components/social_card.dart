import 'package:inventory_scanner/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key, // Make the Key nullable
    required this.icon, // Use required to ensure icon is provided
    this.press, // press can be nullable if not every SocialCard needs to be clickable
  }) : super(key: key);

  final String icon;
  final VoidCallback? press; // Use VoidCallback for callback functions

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized at the start of build if it's not already done elsewhere
    SizeConfig().init(context);

    return GestureDetector(
      onTap: press,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        decoration: BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
