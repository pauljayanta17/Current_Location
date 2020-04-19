import 'package:flutter/material.dart';
import 'package:loginpagedemo/signinpage.dart';
import 'package:loginpagedemo/userpage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userpage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
    );
  }
}

