import 'package:admin_dashboard/models/Consulta.dart';
import 'package:admin_dashboard/models/Doctor.dart';
import 'package:admin_dashboard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class HistoricoMedico extends StatefulWidget {
  final int type;
  HistoricoMedico(this.type);
  @override
  _HistoricoMedicoState createState() => _HistoricoMedicoState();
}

class _HistoricoMedicoState extends State<HistoricoMedico> {
  DatabaseService databaseService = DatabaseService();

  TextEditingController cedController = TextEditingController();

  List<Consulta> consultas = [];
  final f = NumberFormat("#,##0.0#");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  fetchData() async {
    final ced = cedController.text != '' ? int.parse(cedController.text) : null;
    List<Consulta> consultasRes = widget.type == 0
        ? await databaseService.getConsultasByDoctorCed(
            ced, firstDate, lastDate)
        : await databaseService.getConsultasByPacienteCed(
            ced, firstDate, lastDate);
    consultasRes = consultasRes
        .where((element) =>
            (element.fecha.compareTo(lastDate) == 0 ||
                    element.fecha.compareTo(lastDate) == -1) &&
                (element.fecha.compareTo(firstDate) == 0) ||
            element.fecha.compareTo(firstDate) == 1)
        .toList();
    setState(() {
      consultas = consultasRes;
    });
  }

  String formatNumber(String number) {
    var replaceComa = false;
    if (number.contains('.')) replaceComa = true;
    number = number.replaceAll(',', '.');
    if (replaceComa)
      number = number.replaceRange(
          number.lastIndexOf('.'), number.lastIndexOf('.') + 1, ',');
    return number;
  }

  tableRow(Consulta consulta) {
    dynamic pago$ = 0;
    dynamic pagoBss = 0;
    consulta.pago.forEach((e) {
      if (e['formaPago']['moneda'] == 'dolares')
        pago$ += e['monto'];
      else
        pagoBss += e['monto'];
    });
    return TableRow(children: [
      tableCell(formatNumber(f.format(consulta.doctor.ced))),
      tableCell(formatNumber(f.format(consulta.paciente.ced))),
      tableCell(ESPECIALIDADES[consulta.area] ?? 'Sin definir'),
      tableCell(consulta.trabajo),
      tableCell(consulta.observaciones),
      tableCell(formatNumber(f.format(pago$))),
      tableCell(formatNumber(f.format(pagoBss))),
    ]);
  }

  tableCell(String text) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Text(
          text,
          style: CustomLabels.h5,
          textAlign: TextAlign.center,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registro de Médico
              Text(
                  widget.type == 0
                      ? 'Buscar por Doctor'
                      : 'Buscar por Paciente',
                  style: CustomLabels.h1),
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
                      child: Text('Buscar', style: CustomLabels.h4))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Table(
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 2),
                  children: [
                    TableRow(children: [
                      tableCell('Cédula Doctor'),
                      tableCell('Cédula Paciente'),
                      tableCell('Especialidad'),
                      tableCell('Tratamiento'),
                      tableCell('Observaciones'),
                      tableCell('Pago \$'),
                      tableCell('Pago Bs'),
                    ]),
                    ...[for (var consulta in consultas) tableRow(consulta)]
                  ]),
              if (consultas.length == 0) Text('No hay consultas.')
            ],
          )
        ],
      ),
    );
  }
}
