import 'package:admin_dashboard/models/Nota.dart';
import 'package:admin_dashboard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class NotasView extends StatefulWidget {
  @override
  _NotasViewState createState() => _NotasViewState();
}

class _NotasViewState extends State<NotasView> {
  DatabaseService databaseService = DatabaseService();

  TextEditingController cedController = TextEditingController();

  List<Nota> notas = [];

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
    List<Nota> notasRes = await databaseService.getNotas();
    notasRes = notasRes
        .where((element) =>
            (element.fecha.compareTo(lastDate) == 0 ||
                    element.fecha.compareTo(lastDate) == -1) &&
                (element.fecha.compareTo(firstDate) == 0) ||
            element.fecha.compareTo(firstDate) == 1)
        .toList();
    setState(() {
      notas = notasRes;
    });
  }

  tableRow(Nota nota) {
    final dateUS = DateFormat.yMd().format(nota.fecha).split('/');
    return TableRow(children: [
      tableCell('${dateUS[1]}/${dateUS[0]}/${dateUS[2]}'),
      tableCell(nota.contenido.toString()),
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

  Widget formNewNotas() {
    return Row(
      children: [
        Container(
          width: 460,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nueva Nota',
                style: CustomLabels.h1,
              ),
              TextFormField(
                controller: cedController,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              Nota nota = Nota(cedController.text, DateTime.now());
              await databaseService.guardarNota(nota);
              cedController.clear();
              fetchData();
            },
            child: Text('Guardar'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          formNewNotas(),
          SizedBox(height: 40,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registro de Médico
              Text('Notas', style: CustomLabels.h1),
              SizedBox(height: 20),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                spacing: 30.0,
                children: [
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
                      columnWidths: {0: FixedColumnWidth(100.0), 1: FlexColumnWidth(),},
                  children: [
                    TableRow(children: [
                      tableCell('Fecha'),
                      tableCell('Contenido'),
                    ]),
                    ...[for (var nota in notas) tableRow(nota)]
                  ]),
              if (notas.length == 0) Text('No hay notas.')
            ],
          )
        ],
      ),
    );
  }
}
