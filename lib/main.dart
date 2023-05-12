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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    PrinterWeb printerWeb = PrinterWeb('Teste de impressão');

    printerWeb.connectToPrinter(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Teste de impressão',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _printer,
        tooltip: 'Imprimir',
        child: const Icon(Icons.print),
      ),
    );
  }
}
