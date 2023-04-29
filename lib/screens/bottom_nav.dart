import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui';

class BNavigator extends StatefulWidget {
  final Function currentIndex;
  const BNavigator({super.key, required this.currentIndex});

  get controller => null;

  @override
  _BNavigatorState createState() => _BNavigatorState();
}

class _BNavigatorState extends State<BNavigator> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFBF0000),
      unselectedItemColor: Color(0xFF142127).withOpacity(.80),
      selectedFontSize: 15,
      unselectedFontSize: 15,
      currentIndex: index, //New
      onTap: (int i) {
        setState(() {
          index = i;
          widget.currentIndex(i);
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 30), label: 'Expedientes'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 30), label: 'Calendario'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30), label: 'Ajustes')
      ],
    );
  }
}
