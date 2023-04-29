import 'package:flutter/material.dart';
import 'package:legal_app/screens/miCuenta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'nexp_screen.dart';

class HomeScreen extends StatefulWidget {
  //String user;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String user = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //user = prefs.getString('user') ?? '';
      user = prefs.getString('user') ?? '';
    });
    return user;
  }

  /*  @override
  void initState() {
    super.initState();
    _getUser();
  }
 */
  @override
  Widget build(BuildContext context) {
    _getUser();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(body: content())),
    );
  }

  Widget content() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: floatingCard(),
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: carrouselContainer(),
            ),
            Positioned(
              top: 400,
              left: 10,
              right: 10,
              child: qActions(),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget content1() {
    
  } */

  Widget floatingCard() {
    return Material(
      elevation: 20,
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100)),
      child: SizedBox(
        width: 420,
        height: 300,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFF142127),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)),
          ),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 100), child: bienvenida()),
            ],
          ),
        ),
      ),
    );
  }

  Widget bienvenida() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenas Tardes, $user',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.person,
              color: Color(0xFF52C88F),
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return const MiCuentaScreen();
              }));
            },
          ),
        ),
        /* const Padding(
          padding: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFF52C88F),
              size: 45,
            ),
          ),
        ), */
      ],
    );
  }

  Widget carrouselContainer() {
    double screenWidth = MediaQuery.of(context).size.width;
    double carouselWidth = screenWidth * 0.9;
    int _currentCarouselIndex = 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          height: 180,
          width: carouselWidth,
          decoration: BoxDecoration(
            //color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 150,
                viewportFraction: 0.33,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                padEnds: false,
                initialPage: 0,

                //scrollDirection: Axis.horizontal,
              ),
              items: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30), // aumenta el radio de borde a 30
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fact_check,
                          size: 30.0,
                          color: Color(0xFF52C88F),
                        ),
                        const Text('Tareas', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 2.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('9', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),

                ///
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30), // aumenta el radio de borde a 30
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit_calendar,
                          size: 30.0,
                          color: Color(0xFF52C88F),
                        ),
                        const Text('Citas', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 2.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('3', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30), // aumenta el radio de borde a 30
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.api,
                          size: 30.0,
                          color: Color(0xFF52C88F),
                        ),
                        const Text('Autoridades',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 2.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('2', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),

                ///
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30), // aumenta el radio de borde a 30
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.article,
                          size: 30.0,
                          color: Color(0xFF52C88F),
                        ),
                        const Text('Expedientes',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 2.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('30', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),

                ///
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30), // aumenta el radio de borde a 30
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.ads_click,
                          size: 30.0,
                          color: Color(0xFF52C88F),
                        ),
                        const Text('Acuerdos', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 2.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('10', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),

                ///
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30), // aumenta el radio de borde a 30
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 30.0,
                          color: Color(0xFF52C88F),
                        ),
                        const Text('Clientes', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 2.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text('7', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget qActions() {
    return Container(
      alignment: Alignment.center,
      //color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Acciones Rapidas",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF444444),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                       return NExpScreen(getExpedientes: () {},);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, right: 16, bottom: 16, left: 3),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF52C88F),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          width: 70,
                          height: 70,
                          child: const SizedBox(
                            child: Center(
                              child: Text(
                                "🗒",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Text("Nuevo expediente",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, right: 16, bottom: 16, left: 3),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF52C88F),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          width: 70,
                          height: 70,
                          child: const SizedBox(
                            child: Center(
                              child: Text(
                                "🔔",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Text("Notificaciones",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
