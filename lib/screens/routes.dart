import 'package:flutter/material.dart';
import 'package:legal_app/screens/ajustes_screen.dart';
import 'package:legal_app/screens/calendario_screen.dart';
import 'package:legal_app/screens/expedientes_screen.dart';
import 'package:legal_app/screens/home_screen.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      const HomeScreen(),
      const ExpedientesScreen(),
      const CalendarioScreen(),
      const AjustesScreen()
    ];
    return myList[index];
  }
}
