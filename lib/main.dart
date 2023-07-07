import 'package:flutter/material.dart';
import 'home.dart';
import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Pallete.background,
          appBarTheme: const AppBarTheme(backgroundColor: Pallete.background)),
      home: MyHomePage(),
    );
  }
}
