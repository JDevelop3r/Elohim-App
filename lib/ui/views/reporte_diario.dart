import 'package:admin_dashboard/datatables/consultas_datasource.dart';
import 'package:admin_dashboard/models/Comision.dart';
import 'package:admin_dashboard/models/Consulta.dart';
import 'package:admin_dashboard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class ReporteDiario extends StatefulWidget {
  @override
  _ReporteDiarioState createState() => _ReporteDiarioState();
}

class _ReporteDiarioState extends State<ReporteDiario> {
  DatabaseService databaseService = DatabaseService();

  TextEditingController cedController = TextEditingController();

  List<Consulta> consultas = [];
  List<String> doctorsIds = [];
  List<Comision> comisiones = [];

  bool aplicarTransferencia = false;
  bool aplicarPagoMovil = false;
  bool aplicarDesechosBiologicos = false;
  bool aplicarGastosAdministrativos = false;
  bool aplicarDecretoISLR = true;

  DateTime firstDate = DateTime.now().subtract(Duration(days: 7));
  DateTime lastDate = DateTime.now();

  dateButton(Function(DateTime) setDate, DateTime? date, BuildContext context) {
    var dateUS = date != null ? DateFormat.yMd().format(date).split('/') : null;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now())
                .then((newDate) {
              if (newDate != null) setDate(newDate);
            });
          },
        ),
        Text(dateUS != null ? '${dateUS[1]}/${dateUS[0]}/${dateUS[2]}' : '-',
            style: CustomLabels.h4),
      ],
    );
  }

  fetchData() async {
    final ced = cedController.text != '' ? int.parse(cedController.text) : null;
    List<Consulta> consultasRes =
        await databaseService.getConsultasByDoctorCed(ced, firstDate, lastDate);
    consultasRes = consultasRes
        .where((element) =>
            (element.fecha.compareTo(lastDate) == 0 ||
                    element.fecha.compareTo(lastDate) == -1) &&
                (element.fecha.compareTo(firstDate) == 0) ||
            element.fecha.compareTo(firstDate) == 1)
        .toList();
    List<String> ids = [];

    consultasRes.forEach((element) {
      if (!ids.contains(element.doctor.id)) {
        ids.add(element.doctor.id);
      }
    });

    final comisionesRes = await databaseService.getComisiones();
    setState(() {
      doctorsIds = ids;
      consultas = consultasRes;
      comisiones = comisionesRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final consultasDataSource = ConsultasDataSource(
        consultas, doctorsIds, comisiones,
        comisionDesechosBiologicos: aplicarDesechosBiologicos,
        comisionTransferencia: aplicarTransferencia,
        comisionPagoMovil: aplicarPagoMovil,
        comisionGastosAdministrativos: aplicarGastosAdministrativos);
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registro de Médico
              Text('Reporte Diario', style: CustomLabels.h1),
              SizedBox(height: 50),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                spacing: 30.0,
                children: [
                  Container(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cédula'),
                        TextFormField(
                          controller: cedController,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Desde'),
                      dateButton((date) {
                        setState(() {
                          firstDate = date;
                        });
                      }, firstDate, context),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hasta'),
                      dateButton((date) {
                        setState(() {
                          lastDate = date;
                        });
                      }, lastDate, context),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        fetchData();
                      },
                      child: Text('Buscar', style: CustomLabels.h4)),
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        Text(
                          'Aplicar Transferencia',
                          style: CustomLabels.h5,
                        ),
                        Checkbox(
                            value: aplicarTransferencia,
                            onChanged: (value) => setState(
                                () => aplicarTransferencia = value ?? false)),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        Text(
                          'Aplicar Pago Movil',
                          style: CustomLabels.h5,
                        ),
                        Checkbox(
                            value: aplicarPagoMovil,
                            onChanged: (value) => setState(
                                () => aplicarPagoMovil = value ?? false)),
                      ],
                    ),
                  ),
                  Container(
                    width: 280,
                    child: Row(
                      children: [
                        Text(
                          'Aplicar Gastos Administrativos',
                          style: CustomLabels.h5,
                        ),
                        Checkbox(
                            value: aplicarGastosAdministrativos,
                            onChanged: (value) => setState(() =>
                                aplicarGastosAdministrativos = value ?? false)),
                      ],
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Row(
                      children: [
                        Text(
                          'Aplicar Desechos Biológicos',
                          style: CustomLabels.h5,
                        ),
                        Checkbox(
                            value: aplicarDesechosBiologicos,
                            onChanged: (value) => setState(() =>
                                aplicarDesechosBiologicos = value ?? false)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (doctorsIds.isNotEmpty)
                /* ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: MediaQuery.of(context).size.height - 200),
                  child:  */
                PaginatedDataTable(
                  source: consultasDataSource,
                  columns: [
                    DataColumn(label: Text('Nombre Profesional')),
                    ...[
                      for (var entrie in FORMA_PAGO.entries)
                        DataColumn(label: Text(entrie.value))
                    ],
                    DataColumn(label: Text('Total \$')),
                    DataColumn(label: Text('Total Bs')),
                    DataColumn(label: Text('Comisión Platco')),
                    if (aplicarTransferencia)
                      DataColumn(label: Text('Comisión Transferencia')),
                    if (aplicarPagoMovil)
                      DataColumn(label: Text('Comisión Pago Movil')),
                    if (aplicarDesechosBiologicos)
                      DataColumn(label: Text('Desechos Biológicos')),
                    if (aplicarGastosAdministrativos)
                      DataColumn(label: Text('Gastos Administrativos')),
                    if (aplicarDecretoISLR)
                      DataColumn(label: Text('Decreto ISLR')),
                    DataColumn(label: Text('Total a pagar Bs')),
                    DataColumn(label: Text('Exportar')),
                  ],
                ),
              if (doctorsIds.length == 0) Text('No hay consultas.')
            ],
          )
        ],
      ),
    );
  }
}
