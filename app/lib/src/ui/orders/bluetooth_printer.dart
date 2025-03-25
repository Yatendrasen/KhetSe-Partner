import 'dart:convert';
import 'package:admin/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/services.dart';

class BluetoothOrderPrinter extends StatefulWidget {
  const BluetoothOrderPrinter({Key? key}) : super(key: key);

  @override
  State<BluetoothOrderPrinter> createState() => _BluetoothOrderPrinterState();
}

class _BluetoothOrderPrinterState extends State<BluetoothOrderPrinter> {

  AppStateModel appStateModel = AppStateModel();

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bool? ionnected = await appStateModel.bluetoothPrint.isConnected;
    print(ionnected);
    appStateModel.bluetoothPrint.startScan(timeout: Duration(seconds: 10));

    bool isConnected= await appStateModel.bluetoothPrint.isConnected ?? false;

    appStateModel.bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: StreamBuilder<List<BluetoothDevice>>(
        stream: appStateModel.bluetoothPrint.scanResults,
        initialData: [],
        builder: (c, snapshot) => Column(
          children: snapshot.data!.map((d) => ListTile(
            title: Text(d.name??''),
            subtitle: Text(d.address!),
            onTap: () async {
              setState(() {
                _device = d;
              });
              await appStateModel.bluetoothPrint.connect(d);
              print(appStateModel.bluetoothPrint.isConnected);
              //_print();
            },
            trailing: _device!=null && _device!.address == d.address?Icon(
              Icons.check,
              color: Colors.green,
            ):null,
          )).toList(),
        ),
      ),
    );
  }

  _print() async {
    Map<String, dynamic> config = Map();

    List<LineText> list = [];
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'A Title', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'this is conent left', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'this is conent right', align: LineText.ALIGN_RIGHT,linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(type: LineText.TYPE_BARCODE, content: 'A12312112', size:10, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(type: LineText.TYPE_QRCODE, content: 'qrcode i', size:10, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(linefeed: 1));

    ByteData data = await rootBundle.load("assets/images/logo.png");
    List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String base64Image = base64Encode(imageBytes);
    list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));


    await appStateModel.bluetoothPrint.printReceipt(config, list);
  }
}
