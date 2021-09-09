import 'package:admin_dashboard/models/Comision.dart';
import 'package:admin_dashboard/services/database.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class ComisionesView extends StatefulWidget {
  @override
  _ComisionesViewState createState() => _ComisionesViewState();
}

class _ComisionesViewState extends State<ComisionesView> {
  DatabaseService databaseService = DatabaseService();
  List<Comision> comisiones = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), fetchData);
    /* fetchData(); */
  }

  fetchData() async {
    final newComisiones = await databaseService.getComisiones();
    print(newComisiones);
    setState(() {
      comisiones = newComisiones;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Comisiones', style: CustomLabels.h1),
          SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              for (var comision in comisiones)
                _ComisionField(comision: comision)
            ],
          )
        ],
      ),
    );
  }
}

class _ComisionField extends StatefulWidget {
  final Comision comision;

  _ComisionField({required this.comision});

  @override
  __ComisionFieldState createState() => __ComisionFieldState();
}

class __ComisionFieldState extends State<_ComisionField> {
  TextEditingController valor = TextEditingController();

  final DatabaseService databaseService = DatabaseService();
  @override
  initState() {
    valor = TextEditingController(text: '${widget.comision.valor}');
    super.initState();
  }

  onSave() async {
    final newComision =
        Comision(widget.comision.nombre, double.parse(valor.value.text));
    await databaseService.updateComisiones(newComision);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        children: [
          Text(
            widget.comision.toString(),
            style: CustomLabels.h5,
          ),
          Row(
            children: [
              Container(
                width: 90,
                child: TextField(
                  controller: valor,
                  decoration: InputDecoration(hintText: "Valor"),
                ),
              ),
              ElevatedButton(onPressed: onSave, child: Text('Guardar'))
            ],
          ),
        ],
      ),
    );
  }
}
