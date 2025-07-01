import 'package:inventory_scanner/screens/forgot_password/back_icon.dart';
import 'package:inventory_scanner/screens/forgot_password/components/body.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot-password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackIcon(),
        title: Text("Forgot Password"),
      ),
      body: Body(),
    );
  }
}
