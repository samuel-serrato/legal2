import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:legal_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MiCuentaScreen extends StatefulWidget {
  const MiCuentaScreen({Key? key});

  @override
  State<MiCuentaScreen> createState() => _MiCuentaScreenState();
}

class _MiCuentaScreenState extends State<MiCuentaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: content(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: SizedBox(
            height: kToolbarHeight,
            width: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'Mi Cuenta',
              style: TextStyle(fontSize: 24, color: Color(0xFF444444)),
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        const SizedBox(height: 10),
        //listaAjustes(),
        const SizedBox(height: 10),
        /* Expanded(
          child: boton(),
        ), */
      ],
    );
  }

  /*  Widget boton() {
    return ElevatedButton(
      child: Text('Modal Scorll'),
      onPressed: () {
        _abrirModalExpediente();
      },
    );
  }

  Widget buildFood(Food food) => ListTile(
    leading: 
    title: Text(),
  )

  void _abrirModalExpediente() {
    final screenHeight = MediaQuery.of(context).size.height;
    DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, controller) => Container(
        child: ListView.builder(
          controller: controller,
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = buildFood(food);
            
            return buildFood(food)
          },
        ),
      ),
    );
  }
} */
}
