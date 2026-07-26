import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      title: "Scan Mun Jer",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}