import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/screens/add_screen.dart';
import 'package:todo_app_with_rest_api/screens/completed_screen.dart';
import 'package:todo_app_with_rest_api/screens/edit_screen.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) =>  HomeScreen(),
        '/add': (context) =>  AddScreen(),
        '/edit': (context) =>  EditScreen(),
        '/complete': (context) =>  CompletedScreen(),
      },
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}