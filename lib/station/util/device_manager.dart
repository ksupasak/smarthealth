import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class DeviceManager extends StatefulWidget {
  const DeviceManager({Key? key}) : super(key: key);

  @override
  _DeviceManagerState createState() => _DeviceManagerState();
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class _DeviceManagerState extends State<DeviceManager> {
  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);

  

  }
  void start(){

final name = SerialPort.availablePorts.first;
final port = SerialPort(name);
int status = 0;
if (!port.openReadWrite()) {
  print(SerialPort.lastError);
  exit(-1);
}

SerialPortConfig config = port.config; 
config.baudRate = 38400;   
port.config = config;    

  List<int> buffer = [];
     final reader = SerialPortReader(port);
      reader.stream.listen((data) {
     
    
      
       if (data[0] == 42) {
          status = 1;
          
        }

        if(status==1){
          buffer.addAll(data);

          if(buffer.length==11){
               debugPrint('Buffer: $buffer');
          if(buffer[2]==83){
            int spo2 = buffer[5];
            int pulse = buffer[6];
            debugPrint('SpO2: $spo2, Pulse:$pulse');
          
          }
          
          buffer = [];
      


            status = 0 ;
          }
        
        }




    }); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              for (final address in availablePorts)
                Builder(builder: (context) {
                  final port = SerialPort(address);
                  return ExpansionTile(
                    title: Text(address),
                    children: [
                      CardListTile('Description', port.description),
                      CardListTile('Transport', port.transport.toTransport()),
                      CardListTile('USB Bus', port.busNumber?.toPadded()),
                      CardListTile('USB Device', port.deviceNumber?.toPadded()),
                      CardListTile('Vendor ID', port.vendorId?.toHex()),
                      CardListTile('Product ID', port.productId?.toHex()),
                      CardListTile('Manufacturer', port.manufacturer),
                      CardListTile('Product Name', port.productName),
                      CardListTile('Serial Number', port.serialNumber),
                      CardListTile('MAC Address', port.macAddress),
                    ],
                  );
                }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: start,
        ),
      
      ),
    );
  }
}

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  CardListTile(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}