import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/provider/provider.dart';

class InformationCard extends StatefulWidget {
  InformationCard({super.key, this.dataidcard});
  var dataidcard;
  @override
  State<InformationCard> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 2,
                //       spreadRadius: 2,
                //       color: Color.fromARGB(255, 188, 188, 188),
                //       offset: Offset(0, 2)),
                // ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.dataidcard['personal']['picture_url'] == ''
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
                        fontSize: MediaQuery.of(context).size.width * 0.05,
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
                ],
              )),
        ),
      ],
    );
  }
}
