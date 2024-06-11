import 'package:flutter/material.dart';
import 'package:github_repos/src/views/repositories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repositories',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      debugShowCheckedModeBanner: false,
      home: RepositoriesScreen()
    );
  }
}


