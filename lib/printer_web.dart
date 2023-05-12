import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:flutter_web_bluetooth/js_web_bluetooth.dart';

class PrinterWeb {
  final String data;

  PrinterWeb(this.data);

  late String keyService = '000018f0-0000-1000-8000-00805f9b34fb';
  late String keyWrite = '00002af1-0000-1000-8000-00805f9b34fb';

  BluetoothDevice? device;
  List<int> uint8List = [];

  connectToPrinter(BuildContext context) async {
    uint8List = utf8.encode(data);

    try {
      final supported = FlutterWebBluetooth.instance.isBluetoothApiSupported;

      if (!supported) return snackbar(context, msg: 'Navegador não é compatível', contentType: ContentType.failure);

      final requestOptions = RequestOptionsBuilder.acceptAllDevices(
          optionalServices: [keyService]);

      if (device != null) {
        device!.disconnect();
      }

      device = await FlutterWebBluetooth.instance.requestDevice(requestOptions);

      await device!.gatt!.connect().then((server) {
        snackbar(context, msg: 'Conectado a ${device!.name}, impressão em andamento...', contentType:  ContentType.success);
        server
            .getPrimaryService(
              keyService,
            )
            .then(
              (service) async => await _service(context,service),
            )
            .catchError(
          (error) {
            device!.disconnect();
            print('Erro Passo 2 encontrado ao imprimir $error');
          },
        );
      }).catchError(
        (error) {
          device!.disconnect();
          print('Erro Passo 1 encontrado ao imprimir $error');
        },
      );
    } on UserCancelledDialogError {
      snackbar(context, msg: 'Impresão cancelada', contentType: ContentType.failure);
    } on DeviceNotFoundError {
      snackbar(context, msg: 
          'Não há nenhum dispositivo ao alcance das opções definidas acima', contentType: ContentType.failure);
    }
  }

  _service(BuildContext context, WebBluetoothRemoteGATTService service) {
    return service
        .getCharacteristic(
          keyWrite,
        )
        .then((channel) async => await _printerToSend(context, channel))
        .catchError(
      (error) {
        device!.disconnect();
        snackbar(context, msg: 'Erro Passo 3 encontrado ao imprimir $error', contentType: ContentType.failure);
      },
    );
  }

  _printerToSend(BuildContext context,WebBluetoothRemoteGATTCharacteristic channel) {
    return channel
        .writeValueWithResponse(
      Uint8List.fromList(uint8List),
    )
        .then(
      (_) {
        device!.disconnect();
        print('finally');
      },
    ).catchError(
      (error) {
        print(error);
        device!.disconnect();
        snackbar(context, msg: 'Erro Passo 4 encontrado ao imprimir $error',contentType: ContentType.failure );
      },
    );
  }
}

void snackbar(BuildContext context, {required String msg, required ContentType contentType}) {
  final showSnackBar = SnackBar( 
    elevation: 0,
    backgroundColor: Colors.transparent, 
    content: AwesomeSnackbarContent(
      title: 'Opaa!!',
      
      message:
          msg,
      contentType: contentType,
      inMaterialBanner: true,
    ), 
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showSnackBar(showSnackBar);
}
