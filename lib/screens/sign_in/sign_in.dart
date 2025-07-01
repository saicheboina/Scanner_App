import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inventory_scanner/screens/sign_in/components/back_icon.dart';
import 'package:inventory_scanner/screens/sign_in/components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  // Declare a Future variable to hold the initialization result
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase inside the FutureBuilder
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If Firebase initialization is complete, build the UI
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: BackIcon(),
              title: Text("Sign In"),
            ),
            body: Body(),
          );
        }
        // Show a loading indicator while Firebase is initializing
        return CircularProgressIndicator();
      },
    );
  }
}
