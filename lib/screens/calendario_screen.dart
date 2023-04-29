import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'tareasDetalles_screen.dart';
import '../screens/models/tarea.model.dart';
import 'citasDetalles_screen.dart';
import '../screens/models/cita.model.dart';

/* class Task {
  String title;
  String description;
  Task(this.title, this.description);
} */

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreen();
}

class _CalendarioScreen extends State<CalendarioScreen> {
  // Variables de estado.
  DateTime today = DateTime.now();

  Map<DateTime, List<dynamic>> events = {};

  List<dynamic> selectedEvents = [];

  List<Tarea> tareasList = [];
  List<Cita> citasList = [];

  bool arrowDirectionRight = true;
  //Esta variable se utiliza más adelante para determinar la dirección de la flecha que se muestra en la pantalla.

  // Función para manejar el día seleccionado en el calendario.
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day; // Actualiza la fecha seleccionada en el estado del widget
      selectedEvents = _getEventsForRange(
          day); // Actualiza la lista de eventos seleccionados
      _updateListsForRange(
          day); // Actualiza las listas de tareas y citas para el día seleccionado
    });
  }

//funciona para actualizar las listas de tareas y citas con los eventos correspondientes al día seleccionado,
//recorre el diccionario events y verificando si los eventos ocurren en el día seleccionado.
  void _updateListsForRange(DateTime day) {
    tareasList = []; // Reinicia la lista de tareas
    citasList = []; // Reinicia la lista de citas
    for (final key in events.keys) {
      if (isSameDay(key, day)) {
        // Si el evento ocurre en el día seleccionado
        events[key]!.forEach((event) {
          if (event is Tarea) {
            // Si el evento es una tarea
            tareasList.add(event); // Agrega la tarea a la lista de tareas
          } else if (event is Cita) {
            // Si el evento es una cita
            citasList.add(event); // Agrega la cita a la lista de citas
          }
        });
      }
    }
  }

  // Función para obtener eventos para un día específico.
  List<dynamic> _getEventsForRange(DateTime day) {
    final List<dynamic> eventsOfDay = [];
    for (final key in events.keys) {
      if (isSameDay(key, day)) {
        eventsOfDay.addAll(events[key]!);
      }
    }
    return eventsOfDay;
  }

  void updateTarea(Tarea tarea, int index) {
    setState(() {
      // Buscar la tarea existente en la lista `tareasList` usando el índice
      tareasList[index] = tarea;
      // Actualiza la lista `selectedEvents`
      selectedEvents = _getEventsForRange(today);
    });
  }

  void updateCita(Cita cita) {
    setState(() {
      // Actualizar los datos de la cita en el estado
      // (por ejemplo, en la lista `selectedEvents`)
      citasList.add(cita);
      selectedEvents = _getEventsForRange(today);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
          return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: content(today),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                'Calendario',
                style: TextStyle(fontSize: 24, color: Color(0xFF444444)),
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget content(DateTime today) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            calendario(),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView(
                    controller:
                        PageController(viewportFraction: 1, initialPage: 0),
                    children: [
                      tareas(),
                      citas(),
                    ],
                    onPageChanged: (index) {
                      setState(() {
                        arrowDirectionRight = (index == 0) ? true : false;
                      });
                    },
                  ),
                  Positioned(
                    right: arrowDirectionRight ? 10 : null,
                    left: arrowDirectionRight ? null : 10,
                    child: Icon(
                      arrowDirectionRight
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              showAddCitaDialog(context, today);
            },
            child: const Icon(
              Icons.person_add_alt_1,
              color: Color(0xFF52C88F),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 90,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF52C88F),
            onPressed: () {
              showAddTareaDialog(context, today);
            },
            child: const Icon(Icons.post_add_outlined),
          ),
        ),
      ],
    );
  }

  void showAddTareaDialog(BuildContext context, DateTime today) {
    String title = "";
    String description = "";
    int currentIndex =
        -1; // Inicializamos currentIndex en -1, lo que significa que no se está editando ninguna tarea existente
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(
                  hintText: 'Título',
                ),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(
                  hintText: 'Descripción',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Verificar si la lista de eventos para la fecha seleccionada está vacía o no existe
                  if (events[today]?.isEmpty ?? true) {
                    // Si está vacía o no existe, creamos una nueva lista con la nueva tarea y la agregamos a los eventos de la fecha seleccionada
                    events[today] = [Tarea(title, description)];
                  } else {
                    // Si la lista de eventos para la fecha seleccionada ya existe y no está vacía, simplemente agregamos la nueva tarea a la lista existente
                    events[today]!.add(Tarea(title, description));
                  }
                  // Actualizar la lista de eventos para el rango de fechas seleccionado
                  //se está actualizando la lista de tareas que se mostrarán en la pantalla para el día seleccionado.
                  selectedEvents = _getEventsForRange(today);
                });

                if (currentIndex == -1) {
                  // Si currentIndex es -1, significa que se está agregando una nueva tarea
                  // En ese caso, simplemente agregamos la nueva tarea a la lista
                  tareasList.add(Tarea(title, description));
                } else {
                  // Si currentIndex es distinto de -1, significa que se está editando una tarea existente
                  // En ese caso, actualizamos la tarea correspondiente en la lista
                  updateTarea(Tarea(title, description), currentIndex);
                }

                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void showAddCitaDialog(BuildContext context, DateTime today) {
    String title = "";
    String description = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar cita'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(
                  hintText: 'Título',
                ),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(
                  hintText: 'Descripción',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (events[today]?.isEmpty ?? true) {
                    events[today] = [Cita(title, description)];
                  } else {
                    events[today]!.add(Cita(title, description));
                  }
                  //Actualizar el dia seleccionado
                  selectedEvents = _getEventsForRange(today);
                });
                updateCita(Cita(title, description));
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Widget calendario() {
    return SizedBox(
      height: 350,
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.white,
        child: TableCalendar(
          locale: 'es_ES',
          rowHeight: 40,
          headerStyle: const HeaderStyle(
              formatButtonVisible: false, titleCentered: true),
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, today),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: today,
          onDaySelected: _onDaySelected,
          eventLoader: _getEventsForRange,
          calendarStyle: const CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              //borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.rectangle,
              //borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ),
    );
  }

  Widget tareas() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Color(0xFF142127),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Tareas:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (tareasList.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tareasList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: TareasDetalles(
                                    tarea: tareasList[index],
                                    onUpdate: (tarea) {
                                      updateTarea(tarea, index);
                                    }),
                              );
                            },
                          );
                        },
                        splashColor:
                            Colors.blue, // El color de la tinta al presionar
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tareasList[index].title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tareasList[index].description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget citas() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Color(0xFFBF0000),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Citas:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (citasList.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: citasList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: CitasDetalles(
                                    cita: citasList[index],
                                    onUpdate: (cita) {
                                      updateCita(cita);
                                    }),
                              );
                            },
                          );
                        },
                        splashColor:
                            Colors.blue, // El color de la tinta al presionar
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                citasList[index].title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                citasList[index].description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /* Widget btnAgregar(DateTime today) {
    return Container(
      width: double.infinity,
      height: 70,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52C88F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              onPressed: () {
                showAddTareaDialog(context, today);
              },
              child: const Text(
                'Agregar Tarea',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              onPressed: () {
                // Aquí es donde añadirías la lógica que quieres que se ejecute cuando el botón sea presionado.
              },
              child: const Text(
                'Agregar Cita',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } */
}
