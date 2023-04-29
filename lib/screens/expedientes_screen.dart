import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:legal_app/screens/nexp_screen.dart';

import 'package:http/http.dart' as http;

class ExpedientesScreen extends StatefulWidget {
  const ExpedientesScreen({Key? key}) : super(key: key);

  @override
  State<ExpedientesScreen> createState() => _ExpedientesScreenState();
}

/* class ExpedientesService {
  static Future<List<Map<String, dynamic>>> getExpedientes() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.116/APILEGAL/api/expedientes'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener los datos del API.');
    }
  }
}

 */
class _ExpedientesScreenState extends State<ExpedientesScreen> {
  List<Map<String, dynamic>> _expedientes = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getExpedientes();
  }

  Future<void> _getExpedientes() async {
    // establece `_isLoading` en true antes de realizar la solicitud
    setState(() {
      _isLoading = true;
    });

    // Agregar un retraso de 2 segundos

    final response = await http.get(
      Uri.parse('http://192.168.1.116/APILEGAL/api/expedientes'),
      //Uri.parse('http://192.168.0.54/APILEGAL/api/expedientes'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _expedientes =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Error al obtener los datos del API.');
    }

    // establece `_isLoading` en false después de recibir los datos
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                'Expedientes',
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
        btnNuevoExp(),
        const SizedBox(height: 10),
        Expanded(
          child: _isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // muestra el indicador mientras se cargan los datos
              : RefreshIndicator(
                  onRefresh: _getExpedientes, child: expedientes()),
        ),
        const SizedBox(height: 10),
        filtros(context)
      ],
    );
  }

  Widget btnNuevoExp() {
    return Container(
      width: double.infinity,
      height: 90,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF52C88F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return NExpScreen(getExpedientes: _getExpedientes);
              },
            ),
          );
        },
        child: const Text(
          'Nuevo Expediente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget expedientes() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          //decoration: const BoxDecoration(color: Colors.white),
          child: DataTable(
            showCheckboxColumn: false,
            decoration: const BoxDecoration(color: Colors.white),
            dataRowHeight: 100,
            columnSpacing: 10,
            /* headingRowColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xFF52C88F)), */
            columns: const [
              DataColumn(
                  label: SizedBox(
                      width: 100,
                      child: Text(
                        'Expediente Judicial',
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ))),
              DataColumn(
                  label: SizedBox(
                      width: 100,
                      child: Text(
                        'Parte Demandada',
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ))),
              DataColumn(
                  label: SizedBox(
                      width: 100,
                      child: Text(
                        'Fecha de Creación',
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ))),
            ],
            rows: _expedientes.map((expediente) {
              return DataRow(
                selected: false,
                onSelectChanged: (isSelected) {
                  if (isSelected != null && isSelected) {
                    _abrirModalExpediente(expediente);
                  }
                },
                cells: [
                  DataCell(Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        expediente['expedienteJudicial'],
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ))),
                  DataCell(Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      expediente['parteDemandada'],
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )),
                  DataCell(Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      expediente['fechaInicio'],
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _abrirModalExpediente(Map<String, dynamic> expediente) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: SizedBox(
              height: 5,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Stack(children: [
            Container(
              height: screenHeight * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Informacion del Expediente",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ListTile(
                      title: const Text(
                        'Id: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${expediente['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Expediente Judicial: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['expedienteJudicial']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Expediente Interno: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['expedienteInterno']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Grupo: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['grupo']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Abogado: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['abogado']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Parte Actora: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['parteActora']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Parte Demandada: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['parteDemandada']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Descripción: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['descripcion']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Fecha de Inicio: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['fechaInicio']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Fecha de Finalización: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['fechaFinalizacion']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Distrito Judicial: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['distritoJudicial']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Juzgado: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['juzgado']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Materia: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['materia']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Juicio: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['juicio']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Etapas: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['etapas']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                        title: const Text('Recursos: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${expediente['recursos']}',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    ListTile(
                      title: const Text('Fecha de Caducidad: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['fechaCaducidad']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Suerte Principal: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['suertePrincipal']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Fecha Vencimiento Pagaré: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['fechaVencimientoPagare']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Honorarios: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['honorarios']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Comisiones: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['comisiones']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Autoridades: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['autoridades']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: const Text('Clientes: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expediente['clientes']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            /* Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {},
                child: const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                ),
              ),
            ), */
          ]),
        ]);
      },
    );
  }

  Widget filtros(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: screenHeight * 0.08,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color.fromARGB(255, 178, 178, 178)),
        onPressed: () {
          late String? selectedOption = "Ordenar Por:";
          late String? selectedOption2 = "Buscar:";
          late String? selectedOption3 = "Tipo de Juicio:";

          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  //Container de contenido vaya del modalbottomsheet
                  //color: Colors.black,
                  height: 450,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //se pone en columna, se pondrá primero el container de texto y abajo el otro container de el contenido
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                        width: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        //Container del texto
                        //color: Colors.blue,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Filtros',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF444444),
                            ),
                          ),
                        ),
                      ), //Fin de container de texto
                      //const SizedBox(height: 16.0),
                      Expanded(
                        //Expanded para que el container use todo el espacio
                        child: Container(
                          //Container de todo el contenido
                          //color: Colors.red,
                          alignment: Alignment.center,
                          child: Column(
                            //Columna para colocar el contenido uno debajo de otro
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Hijos de Column que a la vez Column es hijo del Container
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  //Se agrega una fila dentro de la columna, donde tendrá dos hijos, dos "DdB"
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: null,
                                        hint: const Text('Ordenar Por'),
                                        onChanged: (String? newValue) {
                                          // Acción que se realiza cuando cambia la opción seleccionada
                                        },

                                        ///
                                        items: <String>['Opcion 1', 'Opcion 2']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        underline: Container(
                                          height: 2,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color(0xFF48B461),
                                                // Aquí puedes cambiar el color de la línea debajo
                                                width:
                                                    1, // Aquí puedes cambiar el ancho de la línea debajo
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: null,
                                        hint: const Text('Buscar'),
                                        onChanged: (String? newValue) {
                                          // Acción que se realiza cuando cambia la opción seleccionada
                                        },

                                        ///
                                        items: <String>['Opcion 1', 'Opcion 2']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        underline: Container(
                                          height: 2,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color(0xFF48B461),
                                                // Aquí puedes cambiar el color de la línea debajo
                                                width:
                                                    1, // Aquí puedes cambiar el ancho de la línea debajo
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  //Segunda Fila dentro de la columna, donde tendrá de hijos un "DdB" y al lado un ElevatedButton
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: null,
                                        hint: const Text('Tipo de Juicio'),
                                        onChanged: (String? newValue) {
                                          // Acción que se realiza cuando cambia la opción seleccionada
                                        },

                                        ///
                                        items: <String>['Opcion 1', 'Opcion 2']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        underline: Container(
                                          height: 2,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color(0xFF48B461),
                                                // Aquí puedes cambiar el color de la línea debajo
                                                width:
                                                    1, // Aquí puedes cambiar el ancho de la línea debajo
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Acción del segundo botón de la segunda fila
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF52C88F),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text("Buscar Expedientes"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                //Container donde tendrá un TextField o campot de texto, no es necesario un row,
                                //pues no tendrá elementos al lado
                                width: 300,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    hintText: "Escriba el Criterio",
                                    enabledBorder: UnderlineInputBorder(
                                      //borderRadius: BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                        color: Color(0xFF48B461),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ), //Fin del Container de TextField
                              //const SizedBox(height: 20),
                              ElevatedButton(
                                //Ultimo botón de la columna
                                onPressed: () {
                                  // Acción del tercer botón
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF52C88F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Buscar por Criterio:"),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          //Fin de BottomModal
        },
        //Fin de la Funcion cuando se presiona filtros
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              child: Center(
                  child: Icon(
                Icons.filter_list,
                size: 40,
                color: Color(0xFF444444),
              )),
            ),
            //SizedBox(width: 16),
            Text(
              "Filtros",
              style: TextStyle(fontSize: 22, color: Color(0xFF444444)),
            ),
          ],
        ),
      ),
    );
  }
}
