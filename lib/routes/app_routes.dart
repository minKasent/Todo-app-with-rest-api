import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/screens/add_screen.dart';
import 'package:todo_app_with_rest_api/screens/completed_screen.dart';
import 'package:todo_app_with_rest_api/screens/edit_screen.dart';
import 'package:todo_app_with_rest_api/screens/home_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String add = '/add';
  static const String edit = '/edit';
  static const String complete = '/complete';

  static final routes = <String, WidgetBuilder>{
    home: (context) => HomeScreen(),
    add: (context) => AddScreen(),
    edit: (context) => EditScreen(),
    complete: (context) => CompletedScreen(),
  };
}
