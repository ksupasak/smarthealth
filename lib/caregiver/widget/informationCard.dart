import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:http/http.dart' as http;

class InformationCard extends StatefulWidget {
  InformationCard({super.key, this.dataidcard, required this.listdata});
  var dataidcard;
  List listdata = [];
  @override
  State<InformationCard> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  bool? status_internet;
  Timer? timer;
  void lop() {
    timer = Timer.periodic(Duration(seconds: 1), (t) async {
      if (status_internet != context.read<DataProvider>().status_internet) {
        status_internet = context.read<DataProvider>().status_internet;
        if (context.read<DataProvider>().resTojson == null) {
          if (context.read<DataProvider>().status_internet == true) {
            var url = Uri.parse(
                '${context.read<DataProvider>().platfromURL}/check_q');
            var res = await http.post(url, body: {
              'care_unit_id': context.read<DataProvider>().care_unit_id,
              'public_id': context.read<DataProvider>().id,
            });
            var resTojson = json.decode(res.body);

            if (resTojson['message'] == 'not found patient') {
            } else {
              setState(() {
                context.read<DataProvider>().resTojson = resTojson;
              });
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    lop();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.dataidcard != null
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.height * 0.12,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
                            widget.dataidcard['personal']['picture_url'] == ''
                                ? Container(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    child: Image.asset('assets/user (1).png'))
                                : Image.network(
                                    '${widget.dataidcard['personal']['picture_url']}',
                                    fit: BoxFit.fill,
                                  ))),
              ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            "${widget.dataidcard['personal']['first_name']}" +
                                '  ' +
                                "${widget.dataidcard['personal']['last_name']}",
                            style: TextStyle(
                              fontFamily: context.read<DataProvider>().family,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Color(0xff48B5AA),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          "${widget.dataidcard['personal']['public_id']}",
                          style: TextStyle(
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Color(0xff1B6286),
                          ),
                        ),
                        context.read<DataProvider>().user_name != null &&
                                context.read<DataProvider>().user_name != ''
                            ? Text(
                                'ผู้ตรวจ: ${context.read<DataProvider>().user_name}',
                                style: TextStyle(
                                  fontFamily:
                                      context.read<DataProvider>().family,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  color: Color(0xff1B6286),
                                ),
                              )
                            : Text(
                                'ผู้ตรวจ: ไม่มีผู้ตรวจ',
                                style: TextStyle(
                                  fontFamily:
                                      context.read<DataProvider>().family,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  color: Color(0xff1B6286),
                                ),
                              )
                      ],
                    )),
              ),
            ],
          )
        : offline();
  }

  Widget offline() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: MediaQuery.of(context).size.height * 0.12,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                      color: Color.fromARGB(255, 240, 240, 240),
                      child: Image.asset('assets/user (1).png')))),
        ),
        Container(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: widget.listdata.length == 0
                        ? Text(
                            "${context.read<DataProvider>().creadreader[1]} ${context.read<DataProvider>().creadreader[2]} ${context.read<DataProvider>().creadreader[4]}",
                            style: TextStyle(
                              fontFamily: context.read<DataProvider>().family,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Color(0xff48B5AA),
                            ),
                          )
                        : Text(
                            "${widget.listdata[1]}  ${widget.listdata[2]} ${widget.listdata[4]}",
                            style: TextStyle(
                              fontFamily: context.read<DataProvider>().family,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Color(0xff48B5AA),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Text(
                    context.read<DataProvider>().id,
                    style: TextStyle(
                      fontFamily: context.read<DataProvider>().family,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Color(0xff1B6286),
                    ),
                  ),
                  context.read<DataProvider>().user_name != null &&
                          context.read<DataProvider>().user_name != ''
                      ? Text(
                          'ผู้ตรวจ: ${context.read<DataProvider>().user_name}',
                          style: TextStyle(
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Color(0xff1B6286),
                          ),
                        )
                      : Text(
                          'ผู้ตรวจ: ไม่มีผู้ตรวจ',
                          style: TextStyle(
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Color(0xff1B6286),
                          ),
                        )
                ],
              )),
        ),
      ],
    );
  }
}
