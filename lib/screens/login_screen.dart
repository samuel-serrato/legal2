import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legal_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  //String user;
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color(0xFF142127),
        body: content(userController, passwordController, context),
      ),
    );
  }

  Widget content(userController, passwordController, context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            /* image: DecorationImage(
              image: NetworkImage(
                  "https://preview.redd.it/51q7icnfycl91.jpg?width=640&crop=smart&auto=webp&s=952cecc3e36ff19e54cf293e3cebebb88033b54e"),
              fit: BoxFit.cover) */
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo(),
              floatingCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      child: SizedBox(
        width: 300,
        height: 130,
        child:
            Image.asset('assets/ingenia_legal_logo.png', fit: BoxFit.fitWidth),
      ),
    );
  }

  Widget floatingCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: 400,
        height: 550,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              title(),
              campoUser(),
              campoPassword(),
              btnLogin(userController, passwordController, context),
              txtConnectService()
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Bienvenido",
            style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 35.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget campoUser() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value == "") {
            return 'No puedes dejar el campo User Vacío';
          }
          /*  if (value != "samuel") {
            return 'Usuario o contraseña incorrecta';
          }
          return null; */
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person, color: Color(0xFF48B461)),
          enabledBorder: UnderlineInputBorder(
              //borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
            color: Color(0xFF48B461),
            width: 2,
          )),
          hintText: "User",
          //hintStyle: TextStyle(color: Color(0xFF48B461)),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget campoPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == "") {
            return 'No puedes dejar el campo Password Vacío';
          }
          /* if (value != "123") {
            return 'Usuario o contraseña incorrecta';
          }
          return null; */
        },
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Color(0xFF48B461)),
          enabledBorder: UnderlineInputBorder(
              //borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
            color: Color(0xFF48B461),
            width: 2,
          )),
          hintText: "Password",
          //hintStyle: TextStyle(color: Color(0xFF48B461)),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget btnLogin(userController, passwordController, context) {
    return Container(
        width: 500,
        height: 120,
        margin: const EdgeInsets.only(top: 70),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: FloatingActionButton(
            elevation: 0,
            heroTag: "FAB_Btn_Api",
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            //padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            onPressed: () async {
              if (isLoading) return;
              setState(() => isLoading = true);
              //await Future.delayed(const Duration(seconds: 2));

              final user = userController.text;
              final password = passwordController.text;

              if (user.isEmpty || password.isEmpty) {
                setState(() => isLoading = false);
                _showAlertDialog(context, "Alerta",
                    "Completa todos los Campos para Iniciar");
              } else {
                try {
                  final response = await http
                      .get(Uri.parse(
                          'http://192.168.1.116/APILEGAL2/api/usuarios'))
                      .timeout(const Duration(seconds: 10));
                  //.get(Uri.parse(
                  //  'http://192.168.0.54/APILEGAL/api/usuarios'))
                  //.timeout(const Duration(seconds: 10));

                  final data = json.decode(response
                      .body); //nos regresa una lista de objetos, que sería
                  //el conjunto de el usuario, con su id y contraseña

                  //También, la función json.decode() se utiliza para convertir la cadena de texto json en un objeto
                  //en este caso, la cadena json es la respuesta de la solicitud HTTP, que se obtiene a través de la propiedad body
                  //del objeto response.

                  //en resumen se obtiene en en la peticion http, en texto json y con json.decode(),
                  //se convierte en una lista de objetos.|
                  //Si los datos no están vacios, se crea variable auxiliar foundUser, se inicializa en false
                  //para validar después si son validos los datos de ingresados

                  bool foundUser = false;
                  //Ciclo for en el que  revisa los campos de la api que vienen desde la bd,
                  //usuario y contraseña respectivamente y lo compara con lo escrito en los textField
                  for (var item in data) {
                    //es una forma rápida de hacer un recorrido en los datos de
                    //una lista, en este caso los items son los campos 'usuario' y 'contraseña' que están en
                    if (item['USUARIO'] == user &&
                        item['PASSWORD'] == password) {
                      //guarda los datos del user en shared preferences para usarlos posteriormente
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('user', user);

                      //Se envía a la otra pantalla
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return const HomePage();
                      }));

                      //Se cambia la variable a true, es decir se encontró que los datos
                      //escritos corresponden a un usuario en el sistema
                      foundUser = true;
                      break;
                    }
                  } //Si al terminar el bucle foundUser sigue siendo false, significa que no se encontró
                  //ningún usuario válido, y se muestra el mensaje "Datos Incorrectos".

                  //Aquí se hace uso de la variable auxiliar, si no se encontraron usuarios viene en FALSE,
                  //y al negar se convierte en true, entonces porque no se encontró ningún usuario que
                  //coincida con los datos ingresados por el usuario.
                  if (!foundUser) {
                    _showAlertDialog(context, "Alerta", "Datos Incorrectos");
                  }
                } catch (e) {
                  print("Error al hacer la solicitud HTTP: $e");
                  _showAlertDialog(context, "Error",
                      "Ocurrió un error al hacer la solicitud HTTP. Por favor, intenta de nuevo más tarde.");
                } finally {
                  setState(() => isLoading = false);
                }
              }
            },
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Ingresar",
                    style: TextStyle(fontSize: 25),
                  )));
  }

  /*  ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(width: 24),
                  Text('Por favor Espera')
                  ],
                )
              : const Text(
                  "Ingresar",
                  style: TextStyle(fontSize: 25),
                )),
    );
  } */

  //Función separada para llamar sin tanto código un ShowAlertDialog
  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Container(
                color: const Color.fromARGB(255, 0, 39, 107),
                child: TextButton(
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget txtConnectService() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Conectar con el Servicio",
            style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
