import 'package:flutter/material.dart';
import 'package:legal_app/screens/login_screen.dart';
import 'package:legal_app/screens/miCuenta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui';
import 'package:settings_ui/settings_ui.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreen();
}

class _AjustesScreen extends State<AjustesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
          return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: content(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                'Ajustes',
                style: TextStyle(fontSize: 24, color: Color(0xFF444444)),
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        const SizedBox(height: 10),
        listaAjustes(),
        const SizedBox(height: 10),
        Expanded(child: btnLogout())
      ],
    );
  }

  Widget listaAjustes() {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.65,
      child: Material(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF52C88F),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Mi cuenta'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Acción que se realiza cuando se toca "Mi cuenta"
                Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return const MiCuentaScreen();
          }));
              },
            ),
            ListTile(
              title: const Text('Configuración de privacidad'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Acción que se realiza cuando se toca "Configuración de privacidad"
              },
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'General',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF52C88F),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              trailing: Switch(
                value: false, // valor de estado de la opción
                onChanged: (bool newValue) {
                  // Acción que se realiza cuando cambia el valor del Switch
                },
              ),
            ),
            /* ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Idioma'),
              trailing: DropdownButton<String>(
                value: 'Español', // valor de estado de la opción
                onChanged: (String? newValue) {
                  // Acción que se realiza cuando cambia la opción seleccionada
                },
                items: <String>['Español', 'Inglés', 'Portugués']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ), */
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Seguridad'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Acción que se realiza cuando se toca "Seguridad"
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget btnLogout() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBF0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          minimumSize: Size(300, 50),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return const LoginScreen();
          }));
          // Navigator.of(context).pop();
          //Navigator.pop(context);
          // Acción que se realiza al presionar el botón
        },
        child: const Text(
          'Cerrar sesión',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
