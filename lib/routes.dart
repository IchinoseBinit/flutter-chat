import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/authenticate_screen/authenticate_screen.dart';
import 'package:flutter_chat/screens/home/home.dart';
import 'package:flutter_chat/screens/splash_screen/splash_loading.dart';

// We use name route
// All our routes will be available here

final Map<String, WidgetBuilder> routes = {
  SplashLoadingScreen.routeName: (context) => SplashLoadingScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  AuthenticateScreen.routeName: (context) => AuthenticateScreen(),
};
