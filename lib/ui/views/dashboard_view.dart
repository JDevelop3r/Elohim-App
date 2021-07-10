import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  TextEditingController dateController = TextEditingController();

  TextEditingController dateConsultController = TextEditingController();

  int? formaPago = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(physics: ClampingScrollPhysics(), children: [
        Column(
          children: [
            // Registro de paciente
            Text('Registro de Paciente', style: CustomLabels.h1),
            SizedBox(height: 50),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 30.0,
              spacing: 100.0,
              children: [
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombres'),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Apellidos'),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cédula'),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dirección'),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha Ingreso'),
                      TextFormField(
                        controller: dateController,
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: 'yyyy/mm/dd',
                            suffix: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now())
                                    .then((value) => dateController.text = value
                                            ?.toIso8601String()
                                            .substring(
                                                0,
                                                value
                                                    .toIso8601String()
                                                    .indexOf('T')) ??
                                        '');
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Registrar Paciente',
                    style: TextStyle(fontSize: 21),
                  ),
                )),
            // Registro de consulta
            SizedBox(
              height: 50.0,
            ),
            Text('Registro de Consulta', style: CustomLabels.h1),
            SizedBox(height: 50),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 18.0,
              spacing: 12.0,
              children: [
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Especialidad Médica'),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trabajo Realizado'),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha de Consulta'),
                      TextFormField(
                        controller: dateConsultController,
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: 'yyyy/mm/dd',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            suffix: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now())
                                    .then((value) => dateController.text = value
                                            ?.toIso8601String()
                                            .substring(
                                                0,
                                                value
                                                    .toIso8601String()
                                                    .indexOf('T')) ??
                                        '');
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Observaciones'),
                      TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Ej: Pago 50%',
                              suffix: Icon(Icons.edit_location_alt_sharp))),
                    ],
                  ),
                ),
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Forma de pago'),
                      DropdownButton<int>(
                        value: formaPago,
                        hint: Text('Selecciona forma de pago'),
                        items: [
                          DropdownMenuItem<int>(
                              child: Text('Efectivo'), value: 0),
                          DropdownMenuItem<int>(child: Text('Punto'), value: 1),
                          DropdownMenuItem<int>(child: Text('Zelle'), value: 2),
                        ],
                        onChanged: (value) => setState(() => formaPago = value),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Registrar Consulta',
                    style: TextStyle(fontSize: 21),
                  ),
                ))
          ],
        ),
      ]),
    );
  }
}
