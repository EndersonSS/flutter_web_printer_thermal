import 'package:flutter/material.dart';
import 'package:flutter_web_printer_thermal/printer_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web printer test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Teste de impressão'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _printer() {
    String format =
        // ignore: prefer_interpolation_to_compose_strings
        '\x1B' +
            '\x61' +
            '\x31' +
            '\x1D' +
            '\x21' +
            '\x00' +
            'REALIZANDO TESTE DE IMP\n\n' +
            '\x1B' +
            '\x45' +
            '\x0D' +
            '================================\n';
    PrinterWeb printerWeb = PrinterWeb(format);

    printerWeb.connectToPrinter(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _printer,
        tooltip: 'Imprimir',
        child: const Icon(Icons.print),
      ),
    );
  }
}
