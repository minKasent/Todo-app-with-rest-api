import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_with_rest_api/models/auth_response.dart';
import 'package:todo_app_with_rest_api/models/auth_schema.dart';
import 'package:todo_app_with_rest_api/models/user_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var users = [];

  AuthResponse? authResponse;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // getAllUsers();
    super.initState();
  }

  Future<List<User>> getAllUsers() async {
    String url = 'https://dummyjson.com/users';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = convert.jsonDecode(
        response.body,
      );
      final List<dynamic> userListJson = jsonResponse['users'];

      // Map each JSON object in the list to a User object.
      return userListJson
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (authResponse != null)
              Text(
                'You have pushed the button this many times: ${authResponse!.email}',
              ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            FutureBuilder(
              future: getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('Result: ${snapshot.data![0].email}');
                    }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          authResponse = await loginUser(
            username: 'emilys',
            password: 'emilyspass',
          );
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<AuthResponse?> loginUser({
    required String username,
    required String password,
  }) async {
    final String loginApiUrl =
        'https://dummyjson.com/auth/login'; // Login API URL

    try {
      final Map<String, dynamic> requestBody = {
        'username': username,
        'password': password,
      };

      final response = await http.post(
        Uri.parse(loginApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(requestBody),
        // body: convert.jsonEncode(
        //   AuthSchema(username: username, password: password).toJson(),
        // ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = convert.jsonDecode(
          response.body,
        );
        return AuthResponse.fromJson(jsonResponse);
      } else {
        print('Failed to login: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
