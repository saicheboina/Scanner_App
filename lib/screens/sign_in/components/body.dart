import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_scanner/components/no_account_text.dart';
import 'package:inventory_scanner/screens/Camera_Screen/CameraPage.dart';
import 'package:inventory_scanner/screens/sign_in/components/sign_form.dart';
import 'package:inventory_scanner/components/social_card.dart'; // Corrected page name
import 'package:inventory_scanner/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Future<void> _signInWithGoogle(BuildContext context) async {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = authResult.user;
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CameraPage()), // Corrected page name
            );
          }
        }
      } catch (error) {
        print("Error signing in with Google: $error");
        // Handle the error here
      }
    }

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(SizeConfig.screenHeight! * 0.06)),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(SizeConfig.screenHeight! * 0.08)),
                SigninForm(),
                SizedBox(height: getProportionateScreenHeight(SizeConfig.screenHeight! * 0.08)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {
                        _signInWithGoogle(context);
                      },
                    ),
                    // Add other social media buttons here if needed
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}