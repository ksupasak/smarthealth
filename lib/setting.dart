import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smart_health/settinglist.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String password = '';
  String passwordcal = '';
  void cal() {
    for (int x = passwordcal.length + 1; password.length >= x; x++) {
      passwordcal = passwordcal + '*';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
            child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 70, 180, 170),
                Colors.white,
              ],
            ),
          ),
        )),
        Positioned(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "PASSWORD",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 170, 170, 170),
                      offset: Offset(0, 0),
                      blurRadius: 1)
                ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$passwordcal",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: (MediaQuery.of(context).size.width +
                                  MediaQuery.of(context).size.height) *
                              0.012,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 170, 170, 170),
                      offset: Offset(0, 0),
                      blurRadius: 2)
                ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '7';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '8';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '8',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '9';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '9',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '4';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '4',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '5';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '6';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '6',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '1';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '2';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '3';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    "กลับ",
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (password.length <= 10) {
                                    password = password + '0';
                                    cal();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  password = '';
                                  passwordcal = '';
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.18,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: Text(
                                    'ลบ',
                                    style: TextStyle(
                                        fontSize:
                                            (MediaQuery.of(context).size.width +
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                0.012,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => settinglist()));
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(blurRadius: 10, color: Colors.green)
                          ]),
                      child: Center(
                          child: Text(
                        'ข้าม',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ))
      ]),
    );
  }
}
