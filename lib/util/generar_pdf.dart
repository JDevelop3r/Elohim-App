// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:admin_dashboard/models/Consulta.dart';
import 'package:admin_dashboard/models/Doctor.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String formatNumber(String number) {
  var replaceComa = false;
  if (number.contains('.')) replaceComa = true;
  number = number.replaceAll(',', '.');
  if (replaceComa)
    number = number.replaceRange(
        number.lastIndexOf('.'), number.lastIndexOf('.') + 1, ',');
  return number;
}

Future generarPDFPago(Doctor doctor, List<Consulta> consultasDoc,
    Map<String, dynamic> pagos) async {
  final fecha = DateTime.now().toString().split(' ')[0].split('-');
  var f = NumberFormat("#,##0.0#");
  try {
    var pagoBss = pagos['pagoBs'] / (doctor.ganancia / 100);
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 =
        pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf"));
    final font2 =
        pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf"));
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        theme: pw.ThemeData.withFont(
          base: font1,
          bold: font2,
        ),
        header: (pw.Context context) {
          if (context.pageNumber != 1) {
            return pw.SizedBox();
          }
          return pw.Container(
              alignment: pw.Alignment.topCenter,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(color: PdfColors.blue600),
              child: pw.Text('RECIBO DE INGRESOS Y TRANSFERENCIAS ',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.white)));
        },
        footer: buildFooter,
        build: (pw.Context context) => <pw.Widget>[
              pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('FECHA: ${fecha[2]}-${fecha[1]}-${fecha[0]}',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('DATOS DEL PROFESIONAL',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'NOMBRE Y APELLIDO',
                  '${doctor.firstName} ${doctor.lastName}',
                ],
                <String>[
                  'ESPECIALIDAD MÉDICA',
                  '${doctor.especialidadToString()}',
                ],
                <String>[
                  'NÚMERO DE CÉDULA',
                  '${doctor.ced}',
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('INGRESOS',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'MONTO POR SERVICIOS',
                  '% CONTRACTUAL',
                  'MONTO PORCENTUAL',
                  'SUB TOTAL',
                ],
                <String>[
                  formatNumber(f.format(pagoBss)),
                  '${doctor.ganancia}',
                  formatNumber(f.format(pagos['pagoBs'])),
                  formatNumber(f.format(pagos['pagoBs']))
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('COMISIONES, EGRESOS y RETENCIONES',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'COMISIÓN\nPLATCO',
                  'COMISIÓN POR\nTRANSF.',
                  'COMISIÓN POR \nMOVIL',
                  'CUOTA\nDESECHOS\nBIOLÓGICOS',
                  'GASTOS\nADMTVOS.',
                  'DECRETO I.S.L.R.'
                ],
                <dynamic>[
                  formatNumber(f.format(pagos['platco'])),
                  formatNumber(f.format(pagos['comision_transferencia'])),
                  formatNumber(f.format(pagos['comision_pago_movil'])),
                  formatNumber(f.format(pagos['desechos_biologicos'])),
                  formatNumber(f.format(pagos['gastos_administrativos'])),
                  formatNumber(f.format(pagos['decreto_islr'])),
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text(
                      'TOTAL MONTO TRANSFERIDO ${formatNumber(f.format(pagos['totalPagar']))}',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
            ]));

    final bodyBytes = await doc.save();
    final blob = html.Blob([bodyBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'Ingresos - ${doctor.firstName} ${doctor.lastName}.pdf';
    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print(e);
  }
}

Future generarPDFComprobante(Doctor doctor, List<Consulta> consultasDoc,
    Map<String, dynamic> pagos, double valorRetencion,
    {double unidadesTributarias = 20000}) async {
  final fecha = DateTime.now().toString().split(' ')[0].split('-');
  final f = NumberFormat("#,##0.##");
  try {
    final sustraendo = unidadesTributarias * 83.33333 * valorRetencion;
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 =
        pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf"));
    final font2 =
        pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf"));
    final razonSocial = 'GRUPO DE ESPECIALIDADES MÉDICAS ELOHIN C.A.';
    final domicilioFiscal =
        'AV. SAN MARTÍN, C.C. LOS MOLINOS, NIVEL AUTOMERCADO, LOCAL 33, CARACAS';
    final nroRif = 'J-403720320';
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        theme: pw.ThemeData.withFont(
          base: font1,
          bold: font2,
        ),
        header: (pw.Context context) {
          if (context.pageNumber != 1) {
            return pw.SizedBox();
          }
          return pw.Container(
              alignment: pw.Alignment.topCenter,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(color: PdfColors.blue600),
              child: pw.Text(
                  'COMPROBANTE DE RETENCIÓN DE IMPUESTO SOBRE LA RENTA',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.white)));
        },
        footer: buildFooter,
        build: (pw.Context context) => <pw.Widget>[
              pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('FECHA: ${fecha[2]}-${fecha[1]}-${fecha[0]}',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('DATOS DEL AGENTE DE RETENCIÓN',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'RAZÓN SOCIAL',
                  razonSocial,
                ],
                <String>[
                  'DOMICILIO FISCAL',
                  domicilioFiscal,
                ],
                <String>[
                  'Nº RIF',
                  nroRif,
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('DATOS DEL CONTIRBUYENTE',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'NOMBRE',
                  '${doctor.firstName} ${doctor.lastName}',
                ],
                <String>[
                  'DOMICILIO FISCAL',
                  '${doctor.domicilioFiscal}',
                ],
                <String>[
                  'Nº RIF',
                  'V-${formatNumber(f.format(doctor.ced))}',
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text('DATOS DEL IMPUESTO RETENIDO',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'MES',
                  'MONTO PORCENTUAL',
                  'BASE RETENCIÓN',
                  '% RETENCIÓN',
                  'VALOR RETENCION',
                ],
                <dynamic>[
                  DateFormat.M().format(DateTime.now()),
                  formatNumber(f.format(pagos['pagoBs'])),
                  formatNumber(f.format(pagos['pagoBs'])),
                  formatNumber(f.format(valorRetencion)),
                  formatNumber(f.format(pagos['decreto_islr'])),
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text(
                      'MENOS APLICACIÓN DEL SUSTRAENDO PARA HP SEGÚN U.T. VIGENTE',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
              pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                <String>[
                  'U.T',
                  'FACTOR',
                  'VALOR DEL SUSTRAENDO',
                  '% RETENCIÓN',
                  'SUSTRAENDO A APLICAR',
                ],
                <dynamic>[
                  unidadesTributarias,
                  '83,333333',
                  '${formatNumber(f.format(unidadesTributarias * 83.33333))}',
                  valorRetencion * 100,
                  '${formatNumber(f.format(unidadesTributarias * 83.33333 * valorRetencion))}',
                ],
              ]),
              pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text(
                      'TOTAL DE IMPUESTO RETENIDO ${formatNumber(f.format(pagos['decreto_islr'] - sustraendo))}',
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.black))),
            ]));

    final bodyBytes = await doc.save();
    final blob = html.Blob([bodyBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download =
          'Comprobate Retención - ${doctor.firstName} ${doctor.lastName}.pdf';
    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print(e);
  }
}

pw.Widget buildFooter(pw.Context context) {
  return pw.Container(
      alignment: pw.Alignment.bottomCenter,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      child: pw.Text(
          'GRUPO DE ESPECIALIDADES MÉDICAS ELOHIN C.A. RIF J-403720320 C.C. LOS MOLINOS, LOCAL 33, AV. SAN MARTIN, CARACAS',
          style: pw.Theme.of(context)
              .defaultTextStyle
              .copyWith(color: PdfColors.black, fontSize: 8)));
}
