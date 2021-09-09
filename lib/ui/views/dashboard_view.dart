import 'package:admin_dashboard/models/Consulta.dart';
import 'package:admin_dashboard/models/Doctor.dart';
import 'package:admin_dashboard/models/Pacient.dart';
import 'package:admin_dashboard/services/database.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DatabaseService databaseService = DatabaseService();

  TextEditingController dateController = TextEditingController();

  TextEditingController dateConsultController = TextEditingController();

  GlobalKey<FormState> formPac = GlobalKey<FormState>();
  GlobalKey<FormState> formCon = GlobalKey<FormState>();

  int cantPagos = 1;
  List<String> formaPago = [];
  List<int> montos = [];

  String? especialidad;

  Pacient pacient = Pacient();

  Consulta consulta = Consulta();

  renderFormaDePago() {
    var dropdowns = [];
    for (var i = 0; i < cantPagos; i++) {
      formaPago.add('efectivo\$');
      montos.add(0);
      dropdowns.add(
        Container(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forma de pago'),
              DropdownButton<String>(
                value: formaPago[i],
                hint: Text('Selecciona forma de pago'),
                items: [
                  DropdownMenuItem<String>(
                      child: Text('Efectivo \$'), value: 'efectivo\$'),
                  DropdownMenuItem<String>(
                      child: Text('Punto'), value: 'debito'),
                  DropdownMenuItem<String>(
                      child: Text('Zelle'), value: 'zelle\$'),
                  DropdownMenuItem<String>(
                      child: Text('Pago Movil'), value: 'pago_movil'),
                  DropdownMenuItem<String>(
                      child: Text('Transferencia'), value: 'transferencia'),
                  DropdownMenuItem<String>(
                      child: Text('Efectivo Bs'), value: 'efectivoBss'),
                  DropdownMenuItem<String>(
                      child: Text('Tarjeta de Crédito'), value: 'credito'),
                  DropdownMenuItem<String>(
                      child: Text('Petro'), value: 'petro'),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => formaPago[i] = value);
                },
              ),
            ],
          ),
        ),
      );
      dropdowns.add(Container(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monto'),
            TextFormField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                montos[i] = int.parse(value.trim());
              },
              validator: (value) {
                if (value == null) return 'Requerido';
                if (value.trim() == '') return 'Requerido';
                var regExp = RegExp(r"^[0-9]+$");
                if (!regExp.hasMatch(value)) return 'Solo números';
              },
            ),
          ],
        ),
      ));
    }
    dropdowns.add(IconButton(
        tooltip: 'Agregar forma de pago',
        icon: Icon(Icons.add),
        onPressed: () => setState(() {
              cantPagos++;
            })));
    return dropdowns;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(physics: ClampingScrollPhysics(), children: [
        Column(
          children: [
            // Registro de paciente
            Text('Registro de Paciente', style: CustomLabels.h1),
            SizedBox(height: 50),
            Form(
              key: formPac,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 30.0,
                spacing: 50.0,
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
                            pacient.firstName = value.trim();
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
                            pacient.lastName = value.trim();
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
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            pacient.ced = int.parse(value.trim());
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            pacient.phone = int.parse(value.trim());
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            pacient.email = value.trim();
                          },
                          validator: (value) {
                            if (value?.trim() == '' || value == null)
                              return 'Requerido';
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
                  if (formPac.currentState?.validate() ?? false) {
                    final res =
                        await databaseService.registrarPaciente(pacient);
                    if (res) formPac.currentState?.reset();
                  }
                },
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
            Form(
              key: formCon,
              child: Wrap(
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
                        Text('Cédula Médico'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            consulta.doctorCed = int.parse(value.trim());
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
                        Text('Cédula Paciente'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            consulta.pacCed = int.parse(value.trim());
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
                        Text('Especialidad Médica'),
                        DropdownButton<String>(
                            value: especialidad,
                            onChanged: (value) =>
                                setState(() => especialidad = value),
                            items: <DropdownMenuItem<String>>[
                              for (var value in ESPECIALIDADES.entries)
                                DropdownMenuItem<String>(
                                  child: Text(value.value),
                                  value: value.key,
                                )
                            ])
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tratamiento Realizado'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            consulta.trabajo = value.trim();
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
                                onPressed: () async {
                                  final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now());
                                  consulta.fecha = date;
                                  dateConsultController.text = date
                                          ?.toIso8601String()
                                          .substring(
                                              0,
                                              date
                                                  .toIso8601String()
                                                  .indexOf('T')) ??
                                      '';
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
                              suffix: Icon(Icons.edit_location_sharp)),
                          onChanged: (value) {
                            consulta.observaciones = value.trim();
                          },
                          validator: (value) {
                            if (value?.trim() == '' || value == null)
                              return 'Requerido';
                          },
                        ),
                      ],
                    ),
                  ),
                  ...renderFormaDePago()
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (formCon.currentState?.validate() ?? false) {
                    if (especialidad == null) return;
                    consulta.area = especialidad;
                    for (var i = 0; i < cantPagos; i++) {
                      if (montos[i] == 0) continue;
                      final pago = {
                        'formaPago': formaPago[i],
                        'monto': montos[i]
                      };
                      consulta.agregarPago = pago;
                    }
                    if (consulta.pago.length == 0) return;
                    final res = await databaseService.registrarPago(consulta);
                    if (!res) return;

                    formCon.currentState?.reset();
                    formaPago.clear();
                    montos.clear();

                    setState(() {
                      cantPagos = 1;
                      especialidad = null;
                    });
                  }
                },
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
