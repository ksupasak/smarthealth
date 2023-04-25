import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/provider/provider.dart';

class PrintQueue extends StatefulWidget {
  const PrintQueue({super.key});

  @override
  State<PrintQueue> createState() => _PrintQueueState();
}

class _PrintQueueState extends State<PrintQueue> {
  var resTojson;
  @override
  void initState() {
    resTojson = context.read<DataProvider>().resTojson;
    print(context.read<DataProvider>().resTojson.toString());
    print('${resTojson['care_name'].toString()}');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Positioned(
            child: BackGroundSmart_Health(
          BackGroundColor: [
            StyleColor.backgroundbegin,
            StyleColor.backgroundend
          ],
        )),
        Positioned(
            child: Center(
          child: Container(
              height: _height * 0.5,
              width: _width * 0.8,
              color: Colors.white,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${resTojson['todays'][0]['care_name'].toString()} '),
                    Text('${resTojson['todays'][0]['slot'].toString()} '),
                  ],
                ),
                Text(
                  '${resTojson['todays'][0]['queue_number'].toString()}',
                  style: TextStyle(fontSize: _width * 0.09),
                ),
                Text(
                    'น้ำหนัก${resTojson['health_records'][0]['weight']}กิโลกรัม'),
              ])),
        ))
      ]),
    );
  }
}
