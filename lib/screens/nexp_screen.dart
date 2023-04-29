import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legal_app/screens/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'expedientes_screen.dart';

class NExpScreen extends StatefulWidget {
  final Function getExpedientes; // Agrega el parámetro aquí

  const NExpScreen({required this.getExpedientes, Key? key}) : super(key: key);

  @override
  State<NExpScreen> createState() => _NExpScreenState();
}

//Aqui se guardan las selecciones del DDB
String _selectedGrupo = "";
String _selectedAbogado = "";
String _selectedDistritoJudicial = "";
String _selectedJuzgado = "";
String _selectedMateria = "";
String _selectedJuicio = "";
String _selectedEtapas = "";
String _selectedRecursos = "";
String _selectedAutoridades = "";
String _selectedClientes = "";

//aqui se guarda la seleccion del dia
String fechaInicio = "";
String _fechaInicioText = '';

String fechaFinalizacion = "";
String _fechaFinalizacionText = "";

String fechaCaducidad = "";
String _fechaCaducidadText = "";

String fechaVencimiento = "";
String _fechaVencimientoText = "";

class _NExpScreenState extends State<NExpScreen> {
  //controllers para cada campo de texto
  final expedienteJudicialController = TextEditingController();
  final expedienteInternoController = TextEditingController();

  final parteActoraController = TextEditingController();
  final parteDemandaController = TextEditingController();
  final descripcionController = TextEditingController();

  final suertePrincipalController = TextEditingController();
  final honorariosController = TextEditingController();
  final comisionesController = TextEditingController();
  final autoridadesController = TextEditingController();
  final clientesController = TextEditingController();

  //Lista donde se almacena lo que se obtengan de la api / DDB
  List<Map<String, dynamic>> _grupo = [];
  List<Map<String, dynamic>> _abogado = [];
  List<Map<String, dynamic>> _distritoJudicial = [];
  List<Map<String, dynamic>> _juzgado = [];
  List<Map<String, dynamic>> _materia = [];
  List<Map<String, dynamic>> _juicio = [];
  List<Map<String, dynamic>> _etapas = [];
  List<Map<String, dynamic>> _recursos = [];
  List<Map<String, dynamic>> _autoridades = [];
  List<Map<String, dynamic>> _clientes = [];

//Se ejecuta al iniciar
  @override
  void initState() {
    super.initState();
    _getData('http://192.168.1.116/APILEGAL/api/grupo', 'grupo');
    _getData('http://192.168.1.116/APILEGAL/api/abogado', 'abogado');
    _getData('http://192.168.1.116/APILEGAL/api/distritojudicial',
        'distritoJudicial');
    _getData('http://192.168.1.116/APILEGAL/api/juzgado', 'juzgado');
    _getData('http://192.168.1.116/APILEGAL/api/materia', 'materia');
    _getData('http://192.168.1.116/APILEGAL/api/juicio', 'juicio');
    _getData('http://192.168.1.116/APILEGAL/api/etapas', 'etapas');
    _getData('http://192.168.1.116/APILEGAL/api/recursos', 'recursos');
    _getData('http://192.168.1.116/APILEGAL/api/autoridades', 'autoridades');
    _getData('http://192.168.1.116/APILEGAL/api/clientes', 'clientes');

    //Variables que contienen el texto Inicial antes de seleccionar fecha
    _fechaInicioText = 'Fecha de Inicio: --/--/----';
    _fechaFinalizacionText = 'Fecha de Finalización: --/--/----';
    _fechaCaducidadText = 'Fecha de Caducidad: --/--/----';
    _fechaVencimientoText = 'Fecha de Vencimiento de Pagaré: --/--/----';
  }

//método genérico que toma como parámetro la URL de la API y el nombre de la lista en la que se
//desea almacenar los datos.
  Future<void> _getData(String url, String listName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        List<Map<String, dynamic>> list =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        switch (listName) {
          //dependiendo el dato que se manda se asigna ese dato a una variable que se llamará
          //despues en en los DDB
          case 'grupo':
            _grupo = list;
            break;
          case 'abogado':
            _abogado = list;
            break;
          case 'distritoJudicial':
            _distritoJudicial = list;
            break;
          case 'juzgado':
            _juzgado = list;
            break;
          case 'materia':
            _materia = list;
            break;
          case 'juicio':
            _juicio = list;
            break;
          case 'etapas':
            _etapas = list;
            break;
          case 'recursos':
            _recursos = list;
            break;
          case 'autoridades':
            _autoridades = list;
            break;
          case 'clientes':
            _clientes = list;
            break;
          // Agrega más casos aquí si necesitas obtener datos para otras listas.
        }
      });
    } else {
      print('Error al obtener los datos del API.');
    }
  }

  //Se guarda la fecha seleccionada, pero despues se le dará fomrato y se guardará en otra variable
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  DateTime _selectedCaducidadDate = DateTime.now();
  DateTime _selectedVencimientoDate = DateTime.now();

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialDate: _selectedStartDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
      },
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        // Formatea la fecha seleccionada y la guarda en la variable fechaInicio
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        fechaInicio = formatter.format(_selectedStartDate);
        // Actualiza el texto que se muestra en el botón con la fecha seleccionada formateada
        _fechaInicioText = 'Fecha de Inicio: $fechaInicio';
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialDate: _selectedEndDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
      },
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        fechaFinalizacion = formatter.format(_selectedEndDate);
        _fechaFinalizacionText = 'Fecha de Finalización: $fechaFinalizacion';
      });
    }
  }

  void _selectCaducidadDate(BuildContext context) async {
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialDate: _selectedCaducidadDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
      },
    );
    if (picked != null && picked != _selectedCaducidadDate) {
      setState(() {
        _selectedCaducidadDate = picked;
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        fechaCaducidad = formatter.format(_selectedCaducidadDate);
        _fechaCaducidadText = 'Fecha de Caducidad: $fechaCaducidad';
      });
    }
  }

  void _selectVencimientoDate(BuildContext context) async {
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          initialDate: _selectedVencimientoDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
      },
    );
    if (picked != null && picked != _selectedVencimientoDate) {
      setState(() {
        _selectedVencimientoDate = picked;
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        fechaVencimiento = formatter.format(_selectedVencimientoDate);
        _fechaVencimientoText =
            'Fecha de Vencimiento de Pagaré: $fechaVencimiento';
      });
    }
  }

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
            //CHECAR ESTO
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
              'Agregar Expediente',
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
        form(),
      ],
    );
  }

  //Funcion para enviar los datos através de la api a la bd
  void enviarDatos() async {
    //Se guarda el texto de los controllers en una variable nueva, que es el que se mandará
    final expedienteJudicial = expedienteJudicialController.text;
    final expedienteInterno = expedienteInternoController.text;
    //Igual con los DDB
    final grupo = _selectedGrupo;
    final abogado = _selectedAbogado;
    final parteActora = parteActoraController.text;
    final parteDemandada = parteDemandaController.text;
    final descripcion = descripcionController.text;
    //final fechaInicio = fechaInicio; YA ESTÁ
    //final fechaFinalizacion = fechaFinalizacion; YA ESTÁ
    final distritoJudicial = _selectedDistritoJudicial;
    final juzgado = _selectedJuzgado;
    final materia = _selectedMateria;
    final juicio = _selectedJuicio;
    final etapas = _selectedEtapas;
    final recursos = _selectedRecursos;
    //final fechaCaducidad = fechaCaducidad; YA ESTÁ
    final suertePrincipal = suertePrincipalController.text;
    final fechaVencimientoPagare = fechaVencimiento;
    final honorarios = honorariosController.text;
    final comisiones = comisionesController.text;
    final autoridades = _selectedAutoridades;
    final clientes = _selectedClientes;

    final url = Uri.parse('http://192.168.1.116/APILEGAL/api/expedientes');
    final response = await http.post(url, body: {
      'expedienteJudicial': expedienteJudicial,
      'expedienteInterno': expedienteInterno,
      'grupo': grupo,
      'abogado': abogado,
      'parteActora': parteActora,
      'parteDemandada': parteDemandada,
      'descripcion': descripcion,
      'fechaInicio': fechaInicio,
      'fechaFinalizacion': fechaFinalizacion,
      'distritoJudicial': distritoJudicial,
      'juzgado': juzgado,
      'materia': materia,
      'juicio': juicio,
      'etapas': etapas,
      'recursos': recursos,
      'fechaCaducidad': fechaCaducidad,
      'suertePrincipal': suertePrincipal,
      'fechaVencimientoPagare': fechaVencimientoPagare,
      'honorarios': honorarios,
      'comisiones': comisiones,
      'autoridades': autoridades,
      'clientes': clientes
    });

    //Se hacen las validaciones con el servidor si se completa la petición o no
    if (response.statusCode == 201) {
      const snackBar = SnackBar(
        content: Text('Expediente agregado con éxito'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      print('Expediente agregado con éxito');
    } else {
      const snackBar = SnackBar(
        content: Text('Error al agregar expediente'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Error al agregar expediente: ${response.statusCode}');
    }
  }

  Widget form() {
    return Expanded(
      child: Container(
        //height: 600,
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: expedienteJudicialController,
                decoration: const InputDecoration(
                    labelText: "Expediente Judicial",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF48B461),
                      width: 1,
                    ))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: expedienteInternoController,
                decoration: const InputDecoration(
                    labelText: "Expediente Interno",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF48B461),
                      width: 1,
                    ))),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  //En el widget DropdownButtonFormField, se asigna la lista _grupo al parámetro items,
                  //que espera una lista de elementos DropdownMenuItem.
                  //Para crear los elementos de la lista, se utiliza el método map para recorrer la lista _grupo y crear un
                  //DropdownMenuItem para cada elemento.
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        //items acepta una lista de objetos DDMI que representa cada opcion del menú
                        //.map se usa para transformar una lista de mapas a una lista de objetos de DDMI
                        items: _grupo.map((gruponame) {
                          // Por cada elemento de _grupo, se crea un objeto DropdownMenuItem
                          // value es el valor seleccionado y se toma de la clave 'nombre' del mapa
                          // child es el contenido de la opción en el menú y también se toma de la clave 'nombre' del mapa
                          return DropdownMenuItem(
                            value: gruponame['nombre'], //valor seleccionado
                            child: Text(gruponame['nombre']), //se muestra lista
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            //se actualiza el contenido de la variable a la opcion que se seleccione
                            //se guarda en la variable el texto del valor seleccionado
                            _selectedGrupo = value as String;
                          });
                          // Aquí puedes agregar la lógica que deseas al seleccionar una opción.
                        },
                        decoration: const InputDecoration(
                            labelText: 'Grupo',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(
                                    0xFF48B461), // Cambia el color de la línea inferior cuando está enfocado aquí
                                width:
                                    1, // Cambia el grosor de la línea inferior cuando está enfocado aquí
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        //.map se usa para transformar una lista de mapas a una lista de objetos de DDMI
                        items: _abogado.map((abogadoname) {
                          return DropdownMenuItem(
                            value: abogadoname['nombre'],
                            child: Text(abogadoname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            //se actualiza el contenido de la variable a la opcion que se seleccione
                            _selectedAbogado = value as String;
                          });
                          // Aquí puedes agregar la lógica que deseas al seleccionar una opción.
                        },
                        decoration: const InputDecoration(
                            labelText: 'Abogado',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(
                                    0xFF48B461), // Cambia el color de la línea inferior cuando está enfocado aquí
                                width:
                                    1, // Cambia el grosor de la línea inferior cuando está enfocado aquí
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(children: [
                TextField(
                  controller: parteActoraController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                    labelText: "Parte Actora",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: parteDemandaController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                    labelText: "Parte Demandada",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descripcionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                    labelText: "Descripción",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF48B461),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(width: 1, color: Colors.green),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          _fechaInicioText,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        onPressed: () => _selectStartDate(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(width: 1, color: Colors.green),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          _fechaFinalizacionText,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        onPressed: () => _selectEndDate(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _distritoJudicial.map((distritojudicialname) {
                          return DropdownMenuItem(
                            value: distritojudicialname['nombre'],
                            child: Text(distritojudicialname['nombre']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDistritoJudicial = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Distrito Judicial',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _juzgado.map((juzgadoname) {
                          return DropdownMenuItem(
                            value: juzgadoname['nombre'],
                            child: Text(juzgadoname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedJuzgado = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Juzgado',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _materia.map((materianame) {
                          return DropdownMenuItem(
                            value: materianame['nombre'],
                            child: Text(materianame['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedMateria = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Materia',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _juicio.map((juicioname) {
                          return DropdownMenuItem(
                            value: juicioname['nombre'],
                            child: Text(juicioname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedJuicio = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Juicio',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _etapas.map((etapasname) {
                          return DropdownMenuItem(
                            value: etapasname['nombre'],
                            child: Text(etapasname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedEtapas = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Etapas',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _recursos.map((recursosname) {
                          return DropdownMenuItem(
                            value: recursosname['nombre'],
                            child: Text(recursosname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedRecursos = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Recursos',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(width: 1, color: Colors.green),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          _fechaCaducidadText,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        onPressed: () => _selectCaducidadDate(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: suertePrincipalController,
                        decoration: const InputDecoration(
                          labelText: "Suerte Principal",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(width: 1, color: Colors.green),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          _fechaVencimientoText,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        onPressed: () => _selectVencimientoDate(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                              value: 'A', child: Text('Porcentaje:')),
                          DropdownMenuItem(
                              value: 'B', child: Text('Mensualidad:')),
                          DropdownMenuItem(
                              value: 'C', child: Text('Pago Único:')),
                        ],
                        onChanged: (value) {
                          // Aquí puedes agregar la lógica que deseas al seleccionar una opción.
                        },
                        decoration: const InputDecoration(
                            labelText: 'Honorarios',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(
                                    0xFF48B461), // Cambia el color de la línea inferior cuando está enfocado aquí
                                width:
                                    1, // Cambia el grosor de la línea inferior cuando está enfocado aquí
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: honorariosController,
                        decoration: const InputDecoration(
                          //HONORARIOS
                          hintText: "0.0", hintStyle: TextStyle(height: 2),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                              value: 'A', child: Text('Porcentaje:')),
                          DropdownMenuItem(
                              value: 'B', child: Text('Mensualidad:')),
                          DropdownMenuItem(
                              value: 'C', child: Text('Pago Único:')),
                        ],
                        onChanged: (value) {
                          // Aquí puedes agregar la lógica que deseas al seleccionar una opción.
                        },
                        decoration: const InputDecoration(
                            labelText: 'Comisiones',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(
                                    0xFF48B461), // Cambia el color de la línea inferior cuando está enfocado aquí
                                width:
                                    1, // Cambia el grosor de la línea inferior cuando está enfocado aquí
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: comisionesController,
                        decoration: const InputDecoration(
                          //COMISIONES
                          hintText: "0.0", hintStyle: TextStyle(height: 2),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _autoridades.map((autoridadesname) {
                          return DropdownMenuItem(
                            value: autoridadesname['nombre'],
                            child: Text(autoridadesname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedAutoridades = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Autoridades',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        items: _clientes.map((clientesname) {
                          return DropdownMenuItem(
                            value: clientesname['nombre'],
                            child: Text(clientesname['nombre']),
                          );
                        }).toList(), //se agrega/convierte a lista para poder seleccionares
                        onChanged: (value) {
                          setState(() {
                            _selectedClientes = value as String;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Clientes',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xFF48B461),
                              width: 1,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF48B461),
                                width: 1,
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              btnAgregar(),
              const SizedBox(height: 70),
              btnGoC()
            ],
          ),
        ),
      ),
    );
  }

  Widget btnAgregar() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF142127),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // Aquí es donde añadirías la lógica que quieres que se ejecute cuando el botón sea presionado.
              },
              child: const Text(
                'Agregar Nueva Autoridad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF142127),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // Aquí es donde añadirías la lógica que quieres que se ejecute cuando el botón sea presionado.
              },
              child: const Text(
                'Agregar Nuevo Cliente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget btnGoC() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF48B461),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                /* print(expedienteJudicialController.text);
                print(expedienteInternoController.text);
                print(_selectedGrupo);
                print(_selectedAbogado);
                
                print(parteActoraController);
                print(parteDemandaController);
                print(descripcionController);

                print(fechaInicio);
                print(fechaFinalizacion);

                print(_selectedDistritoJudicial);
                print(_selectedJuzgado);
                print(_selectedMateria);
                print(_selectedJuicio);
                print(_selectedEtapas);
                print(_selectedRecursos);

                print(fechaCaducidad);

                print(suertePrincipalController);

                print(fechaVencimiento);

                print(honorariosController);
                print(comisionesController);
                
                print(_selectedAutoridades);
                print(_selectedClientes); */

                /*  print(expedienteJudicialController.text);
                print(expedienteInternoController.text);
                print(_selectedGrupo);
                print(_selectedAbogado);
                print(parteActoraController.text);
                print(parteDemandaController.text);
                print(descripcionController.text);
                print(_selectedDistritoJudicial);
                print(_selectedJuzgado);
                print(_selectedMateria);
                print(_selectedJuicio);
                print(_selectedEtapas);
                print(_selectedRecursos);
                print(fechaInicio);
                print(fechaFinalizacion);
                print(fechaCaducidad);
                print(suertePrincipalController.text);
                print(fechaVencimiento);
                print(honorariosController.text);
                print(comisionesController.text);
                print(_selectedAutoridades);
                print(_selectedClientes); */

                //se llama la funcion en la que se envia con http post los datos
                enviarDatos();
                widget.getExpedientes;
                bool camposCompletos = true;

                //Se valida si los campos están vacios o no, y si si están vacios mandará
                //un dialog y un snackbar
                if (expedienteJudicialController.text.isEmpty ||
                    expedienteInternoController.text.isEmpty ||
                    _selectedGrupo == null ||
                    _selectedAbogado == null ||
                    parteActoraController.text.isEmpty ||
                    parteDemandaController.text.isEmpty ||
                    descripcionController.text.isEmpty ||
                    fechaInicio == null ||
                    fechaFinalizacion == null ||
                    _selectedDistritoJudicial == null ||
                    _selectedJuzgado == null ||
                    _selectedMateria == null ||
                    _selectedJuicio == null ||
                    _selectedEtapas == null ||
                    _selectedRecursos == null ||
                    fechaCaducidad == null ||
                    suertePrincipalController.text.isEmpty ||
                    fechaVencimiento == null ||
                    honorariosController.text.isEmpty ||
                    comisionesController.text.isEmpty ||
                    _selectedAutoridades == null ||
                    _selectedClientes == null) {
                  camposCompletos = false;
                }

                if (camposCompletos) {
                  // Realizar la acción que corresponda
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Completa todos los campos'),
                        actions: [
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.of(context).pop(); //CHECAR ESTO
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Guardar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBF0000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
