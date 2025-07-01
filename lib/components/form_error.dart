import 'package:inventory_scanner/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key, // Make the Key nullable
    required this.errors, // Use required to ensure errors list is provided
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized at the start of build if it's not already done elsewhere
    SizeConfig().init(context);

    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({required String error}) {
    // Mark error as required
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: getProportionateScreenWidth(14),
          width: getProportionateScreenWidth(14),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Text(error),
      ],
    );
  }
}
