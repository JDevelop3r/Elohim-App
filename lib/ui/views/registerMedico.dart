import 'package:admin_dashboard/models/Doctor.dart';
import 'package:admin_dashboard/services/database.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class RegisterMedico extends StatefulWidget {
  @override
  _RegisterMedicoState createState() => _RegisterMedicoState();
}

class _RegisterMedicoState extends State<RegisterMedico> {
  DatabaseService databaseService = DatabaseService();

  TextEditingController dateController = TextEditingController();

  TextEditingController dateConsultController = TextEditingController();

  GlobalKey<FormState> formDoc = GlobalKey<FormState>();

  String? especialidad;

  Doctor doctor = Doctor();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(physics: ClampingScrollPhysics(), children: [
        Column(
          children: [
            // Registro de Médico
            Text('Registro de Médico', style: CustomLabels.h1),
            SizedBox(height: 50),
            Form(
              key: formDoc,
              child: Wrap(
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
                          onChanged: (value) {
                            doctor.firstName = value.trim();
                          },
                          validator: (value) {
                            if (value?.trim() == '' || value == null)
                              return 'Requerido';
                          },
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
                          onChanged: (value) {
                            doctor.lastName = value.trim();
                          },
                          validator: (value) {
                            if (value?.trim() == '' || value == null)
                              return 'Requerido';
                          },
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
                          onChanged: (value) {
                            doctor.ced = int.parse(value.trim());
                          },
                          validator: (value) {
                            if (value == null) return 'Requerido';
                            if (value.trim() == '') return 'Requerido';
                            var regExp = RegExp(r"^[0-9]+$");
                            if (!regExp.hasMatch(value))
                              return 'Solo números';
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RIF'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            doctor.rif = int.parse(value.trim());
                          },
                          validator: (value) {
                            if (value == null) return 'Requerido';
                            if (value.trim() == '') return 'Requerido';
                            var regExp = RegExp(r"^[0-9]+$");
                            if (!regExp.hasMatch(value))
                              return 'Solo números';
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Teléfono'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            doctor.phone = int.parse(value.trim());
                          },
                          validator: (value) {
                            if (value == null) return 'Requerido';
                            if (value.trim() == '') return 'Requerido';
                            var regExp = RegExp(r"^[0-9]+$");
                            if (!regExp.hasMatch(value))
                              return 'Solo números';
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Correo'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            doctor.email = value.trim();
                          },
                          validator: (value) {
                            if (value?.trim() == '' || value == null)
                              return 'Requerido';
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Domicilio Fiscal'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            doctor.domicilioFiscal = value.trim();
                          },
                          validator: (value) {
                            if (value?.trim() == '' || value == null)
                              return 'Requerido';
                          },
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
                        DropdownButton<String>(
                          value: especialidad,
                          hint: Text('Selecciona especialidad'),
                          items: [
                            for (var value in ESPECIALIDADES.entries)
                              DropdownMenuItem<String>(
                                  child: Text(value.value), value: value.key),
                          ],
                          onChanged: (value) =>
                              setState(() => especialidad = value),
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
                            if (value == null) return 'Requerido';
                            if (value.trim() == '') return 'Requerido';
                            var regExp = RegExp(r"^[0-9]+$");
                            print(!regExp.hasMatch(value));
                            if (!regExp.hasMatch(value))
                              return 'Solo números';
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(hintText: '50'),
                          onChanged: (value) {
                            doctor.ganancia = int.parse(value.trim());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (formDoc.currentState?.validate() ?? false) {
                    if (especialidad == null) return;
                    doctor.especialidades = [especialidad.toString()];
                    final res = await databaseService.registrarDoctor(doctor);
                    if (!res) return;

                    formDoc.currentState?.reset();
                    setState(() {
                      especialidad = null;
                    });
                  }
                },
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
