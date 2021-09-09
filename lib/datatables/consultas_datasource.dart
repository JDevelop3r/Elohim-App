import 'package:admin_dashboard/models/Comision.dart';
import 'package:admin_dashboard/models/Consulta.dart';
import 'package:admin_dashboard/models/Doctor.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:admin_dashboard/util/generar_pdf.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

String formatNumber(String number) {
  var replaceComa = false;
  if (number.contains('.')) replaceComa = true;
  number = number.replaceAll(',', '.');
  if (replaceComa)
    number = number.replaceRange(
        number.lastIndexOf('.'), number.lastIndexOf('.') + 1, ',');
  return number;
}

class ConsultasDataSource extends DataTableSource {
  final List<Consulta> consultas;
  final List<String> doctorsIds;
  final List<Comision> comisiones;
  final bool comisionTransferencia;
  final bool comisionPagoMovil;
  final bool comisionGastosAdministrativos;
  final bool comisionDesechosBiologicos;
  final bool comisionDecretoISLR;

  ConsultasDataSource(this.consultas, this.doctorsIds, this.comisiones,
      {this.comisionTransferencia = false,
      this.comisionPagoMovil = false,
      this.comisionGastosAdministrativos = false,
      this.comisionDesechosBiologicos = false,
      this.comisionDecretoISLR = true});

  List<DataCell> tableRow(String id) {
    var f = NumberFormat("#,##0.0#");
    dynamic zelle = 0;
    dynamic transferencia = 0;
    dynamic efectivo$ = 0;
    dynamic efectivoBss = 0;
    dynamic pago_movil = 0;
    dynamic debito = 0;
    dynamic credito = 0;
    dynamic otro = 0;
    dynamic pago$ = 0;
    dynamic pagoBss = 0;
    dynamic totalPagar = 0;
    Doctor doctor =
        consultas.where((element) => element.doctor.id == id).first.doctor;
    List<Consulta> consultasDoc =
        consultas.where((element) => element.doctor.id == id).toList();
    Map<String, dynamic> pagos = {};
    consultasDoc.forEach((element) {
      element.pago.forEach((e) {
        if (e['formaPago']['name'] == 'efectivo\$') efectivo$ += e['monto'];
        if (e['formaPago']['name'] == 'zelle\$') zelle += e['monto'];
        if (e['formaPago']['name'] == 'debito') {
          debito += e['monto'];
          totalPagar += e['monto'];
        }
        if (e['formaPago']['name'] == 'transferencia') {
          transferencia += e['monto'];
          totalPagar += e['monto'];
        }
        if (e['formaPago']['name'] == 'pago_movil') {
          pago_movil += e['monto'];
          totalPagar += e['monto'];
        }
        if (e['formaPago']['name'] == 'efectivoBss') {
          efectivoBss += e['monto'];
          totalPagar += e['monto'];
        }
        if (e['formaPago']['name'] == 'credito') {
          credito += e['monto'];
          totalPagar += e['monto'];
        }
        if (e['formaPago']['name'] == 'otro') {
          otro += e['monto'];
          totalPagar += e['monto'];
        }
        if (e['formaPago']['moneda'] == 'dolares')
          pago$ += e['monto'];
        else
          pagoBss += e['monto'];
      });
    });
    pagoBss *= doctor.ganancia / 100;
    pago$ *= doctor.ganancia / 100;
    totalPagar *= doctor.ganancia / 100;
    totalPagar -= debito *
        (doctor.ganancia / 100) *
        comisiones.firstWhere((element) => element.nombre == 'platco').valor;

    if (comisionTransferencia) {
      totalPagar -= pagoBss *
          comisiones
              .firstWhere((element) => element.nombre == 'transferencia')
              .valor;
    }

    if (comisionPagoMovil) {
      totalPagar -= pagoBss *
          comisiones
              .firstWhere((element) => element.nombre == 'pago_movil')
              .valor;
    }

    if (comisionDecretoISLR) {
      totalPagar -= pagoBss *
          comisiones
              .firstWhere((element) => element.nombre == 'decreto_islr')
              .valor;
    }

    if (comisionDesechosBiologicos) {
      totalPagar -= comisiones
          .firstWhere((element) => element.nombre == 'desechos_biologicos')
          .valor;
    }

    if (comisionGastosAdministrativos) {
      totalPagar -= comisiones
          .firstWhere((element) => element.nombre == 'gastos_administrativos')
          .valor;
    }
    pagos.addAll({
      'debito': debito,
      'efectivo\$': efectivo$,
      'efectivoBss': efectivoBss,
      'transferencia': transferencia,
      'zelle\$': zelle,
      'pago_movil': pago_movil,
      'credito': credito,
      'otro': otro,
      'totalPagar': totalPagar,
      'pagoBs': pagoBss,
      'pago\$': pago$,
      'platco': debito *
          (doctor.ganancia / 100) *
          comisiones.firstWhere((element) => element.nombre == 'platco').valor,
      'comision_transferencia': comisionTransferencia
          ? pagoBss *
              comisiones
                  .firstWhere((element) => element.nombre == 'platco')
                  .valor
          : 0,
      'comision_pago_movil': comisionPagoMovil
          ? pagoBss *
              comisiones
                  .firstWhere((element) => element.nombre == 'pago_movil')
                  .valor
          : 0,
      'gastos_administrativos': comisionGastosAdministrativos
          ? comisiones
              .firstWhere(
                  (element) => element.nombre == 'gastos_administrativos')
              .valor
          : 0,
      'desechos_biologicos': comisionGastosAdministrativos
          ? comisiones
              .firstWhere((element) => element.nombre == 'desechos_biologicos')
              .valor
          : 0,
      'decreto_islr': comisionDecretoISLR
          ? pagoBss *
              comisiones
                  .firstWhere((element) => element.nombre == 'decreto_islr')
                  .valor
          : 0,
    });

    return [
      tableCell('${doctor.lastName} ${doctor.firstName}'),
      tableCell(formatNumber(f.format(efectivo$))),
      tableCell(formatNumber(f.format(debito))),
      tableCell(formatNumber(f.format(zelle))),
      tableCell(formatNumber(f.format(transferencia))),
      tableCell(formatNumber(f.format(pago_movil))),
      tableCell(formatNumber(f.format(efectivoBss))),
      tableCell(formatNumber(f.format(credito))),
      tableCell(formatNumber(f.format(otro))),
      tableCell(formatNumber(f.format(pago$))),
      tableCell(formatNumber(f.format(pagoBss))),
      tableCell(formatNumber(f.format(debito *
          (doctor.ganancia / 100) *
          comisiones
              .firstWhere((element) => element.nombre == 'platco')
              .valor))),
      if (comisionTransferencia)
        tableCell(formatNumber(f.format(pagoBss *
            comisiones
                .firstWhere((element) => element.nombre == 'transferencia')
                .valor))),
      if (comisionPagoMovil)
        tableCell(formatNumber(f.format(pagoBss *
            comisiones
                .firstWhere((element) => element.nombre == 'pago_movil')
                .valor))),
      if (comisionDesechosBiologicos)
        tableCell(formatNumber(f.format(comisiones
            .firstWhere((element) => element.nombre == 'desechos_biologicos')
            .valor))),
      if (comisionGastosAdministrativos)
        tableCell(formatNumber(f.format(comisiones
            .firstWhere((element) => element.nombre == 'gastos_administrativos')
            .valor))),
      tableCell(formatNumber(f.format(pagoBss *
          comisiones
              .firstWhere((element) => element.nombre == 'decreto_islr')
              .valor))),
      tableCell(formatNumber(f.format(totalPagar))),
      DataCell(Row(
        children: [
          IconButton(
            tooltip: 'Pagos',
            icon: Icon(Icons.payments),
            onPressed: () async {
              generarPDFPago(doctor, consultasDoc, pagos);
            },
          ),
          IconButton(
            tooltip: 'Retencion',
            icon: Icon(Icons.account_balance),
            onPressed: () async {
              generarPDFComprobante(
                  doctor,
                  consultasDoc,
                  pagos,
                  comisiones
                      .firstWhere((element) => element.nombre == 'decreto_islr')
                      .valor,
                  unidadesTributarias: comisiones
                      .firstWhere(
                          (element) => element.nombre == 'unidad_tributaria')
                      .valor);
            },
          )
        ],
      )),
    ];
  }

  DataCell tableCell(String text) {
    return DataCell(Text(
      text,
      style: CustomLabels.h5,
      textAlign: TextAlign.center,
    ));
  }

  @override
  DataRow getRow(int index) {
    // final Consulta consult = consultas[index];
    return DataRow.byIndex(index: index, cells: tableRow(doctorsIds[index]));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => this.doctorsIds.length;

  @override
  int get selectedRowCount => 0;
}
