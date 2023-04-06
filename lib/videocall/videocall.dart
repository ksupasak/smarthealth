import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Menu.dart';
import 'package:smart_health/provider/Provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoAndMenuindexuser extends StatefulWidget {
  const VideoAndMenuindexuser({super.key});

  @override
  State<VideoAndMenuindexuser> createState() => _VideoAndMenuindexuserState();
}

class _VideoAndMenuindexuserState extends State<VideoAndMenuindexuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Menuindexuser()));
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.amber,
                child: Center(child: Text('Menu')),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Call()));
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.amber,
                child: Center(child: Text('Videocall')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  TextEditingController first_name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController appID = TextEditingController();
  TextEditingController appSign = TextEditingController();
  TextEditingController callID = TextEditingController();
  @override
  void initState() {
    first_name.text = context.read<StringItem>().first_name;
    id.text = context.read<StringItem>().id;
    appID.text = context.read<StringItem>().appID.toString();
    appSign.text = context.read<StringItem>().appSign;
    callID.text = context.read<StringItem>().callID;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: first_name,
              ),
            ),
            Container(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: id,
              ),
            ),
            Container(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: appID,
              ),
            ),
            Container(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: appSign,
              ),
            ),
            Container(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: callID,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  context.read<StringItem>().first_name = first_name.text;
                  //  context.read<StringItem>().id = id.text;
                  context.read<StringItem>().appID = int.parse(appID.text);
                  context.read<StringItem>().appSign = appSign.text;
                  context.read<StringItem>().callID = callID.text;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCall()));
                });
              },
              child: Container(
                color: Colors.green,
                height: 50,
                width: 200,
                child: Center(
                  child: Text('เริ่มวีดีโอ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCall extends StatelessWidget {
  const MyCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 733551517,
      appSign:
          '98418d25e39d83614bd7d3919fca8948d817cf7a2979c3c38a4fe47edebef86a',
      userID: 'test',
      userName: 'test',
      callID: '1234',
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
