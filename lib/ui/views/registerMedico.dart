import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';

class RegisterMedico extends StatefulWidget {
  @override
  _RegisterMedicoState createState() => _RegisterMedicoState();
}

class _RegisterMedicoState extends State<RegisterMedico> {
  TextEditingController dateController = TextEditingController();

  TextEditingController dateConsultController = TextEditingController();

  int? formaPago = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(physics: ClampingScrollPhysics(), children: [
        Column(
          children: [
            // Registro de Médico
            Text('Registro de Médico', style: CustomLabels.h1),
            SizedBox(height: 50),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 30.0,
              spacing: 24.0,
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
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Especialidad'),
                      DropdownButton<int>(
                        value: formaPago,
                        hint: Text('Selecciona especialidad'),
                        items: [
                          DropdownMenuItem<int>(
                              child: Text('Odontología'), value: 0),
                          DropdownMenuItem<int>(
                              child: Text('Ginecología'), value: 1),
                        ],
                        onChanged: (value) => setState(() => formaPago = value),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Porcentaje'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        validator: (value) {
                          var regExp = RegExp(r"^[0-9]*$");
                          if (regExp.allMatches(value ?? '').length != 0)
                            return 'Solo números';
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(hintText: '50'),
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
                    'Registrar Médico',
                    style: TextStyle(fontSize: 21),
                  ),
                )),
          ],
        ),
      ]),
    );
  }
}
