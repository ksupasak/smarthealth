import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyHomePage2 extends StatefulWidget {
  final String? value; // รับ parameter ชื่อ value มาเป็น String

  const MyHomePage2({Key? key, this.value, required BluetoothDevice device})
      : super(key: key); // สร้าง constructor ใหม่รับ parameter ชื่อ value

  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  @override
  void initState() {
    print(widget.value);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyHomePage2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Value from MyHomePage:',
            ),
            Text(
              widget.value ??
                  'No value', // ใช้ค่า value จาก parameter ที่ได้รับมา
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '1235',
            ),
          ],
        ),
      ),
    );
  }
}
