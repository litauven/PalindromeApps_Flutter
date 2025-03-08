import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/first_screen.dart';
import 'screens/second_screen.dart';
import 'screens/third_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Palindrome App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirstScreen(),
        routes: {
          '/second': (context) => SecondScreen(),
          '/third': (context) => ThirdScreen(),
        },
      ),
    );
  }
}
