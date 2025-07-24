import 'package:flutter/material.dart';

class DemoProvider with ChangeNotifier {
  /// priviate variable
  int _counter = 0;
  int _age = 0;

  /// getter
  int get counter => _counter;
  int get age => _age;

  /// setter

  void increment() {
    _counter++; // 1
    print("counter $_counter");

    notifyListeners(); // push noti
  }

  void increateAge() {
    _age++;
    // notifyListeners();
  }
}