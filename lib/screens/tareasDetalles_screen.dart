import 'package:flutter/material.dart';
import '../screens/models/tarea.model.dart';

class TareasDetalles extends StatefulWidget {
  const TareasDetalles({Key? key, required this.tarea, required this.onUpdate})
      : super(key: key);

  final Tarea tarea;
  final Function(Tarea) onUpdate;

  @override
  _TareasDetallesState createState() => _TareasDetallesState();
}

class _TareasDetallesState extends State<TareasDetalles> {
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    _tituloController = TextEditingController(text: widget.tarea.title);
    _descripcionController =
        TextEditingController(text: widget.tarea.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: screenHeight * 0.8,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        padding:
            const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Detalles de la Tarea",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Titulo:  ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tituloController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                //borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  color: Color(0xFF48B461),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Descripción:  ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _descripcionController,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    //borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      color: Color(0xFF48B461),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.tarea.title = _tituloController.text;
                    widget.tarea.description = _descripcionController.text;
                    // guardar los // cambios en la base de datos
                    widget.onUpdate(widget.tarea);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Guardar"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
