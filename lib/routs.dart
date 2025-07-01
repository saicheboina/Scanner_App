import 'package:flutter/material.dart';
import 'package:inventory_scanner/screens/Camera_Screen/CameraPage.dart';
import 'package:inventory_scanner/screens/Export_Page/ListPage.dart';
import 'package:inventory_scanner/screens/product_details/ProductDetailsPage.dart';
import 'package:inventory_scanner/screens/forgot_password/forgot_password_screen.dart';
import 'package:inventory_scanner/screens/sign_in/sign_in.dart';
import 'package:inventory_scanner/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  CameraPage.routeName: (context) => CameraPage(),
  ListPage.routeName: (context) => ListPage(savedProduct: ''),
  ProductDetailsPage.routeName: (context) => ProductDetailsPage(upcCode: ''),
};
