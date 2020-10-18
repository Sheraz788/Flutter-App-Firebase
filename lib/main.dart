import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practices/login.dart';
import 'package:flutter_practices/signup.dart';
import 'package:flutter_practices/home.dart';

void main() {
  runApp(
      MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login' : (context) => Login(),
          '/signup' : (context) => Signup(),
          '/home' : (context) => Home(),

        },
      )
  ); //run app
}










