import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:legal_app/screens/ajustes_screen.dart';
import 'package:legal_app/screens/bottom_nav.dart';
import 'package:legal_app/screens/calendario_screen.dart';
import 'package:legal_app/screens/expedientes_screen.dart';
import 'package:legal_app/screens/home_screen.dart';
import 'package:legal_app/screens/routes.dart';

import 'screens/login_screen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false, //quitar banner de debug
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  BNavigator? myBNB;

  @override
  void initState() {
    myBNB = BNavigator(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: myBNB,
      body: Routes(index: index),
    );
  }
}
