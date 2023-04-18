import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Model/view/widgetdew.dart/popup.dart';
import 'package:smart_health/Model/view/widgetdew.dart/widgetdew.dart';
import 'package:smart_health/povider/provider.dart';

class PopupSetting extends StatefulWidget {
  const PopupSetting({super.key});

  @override
  State<PopupSetting> createState() => _PopupSettingState();
}

class _PopupSettingState extends State<PopupSetting> {
  TextEditingController p1 = TextEditingController();
  TextEditingController p2 = TextEditingController();
  TextEditingController p3 = TextEditingController();
  TextEditingController p4 = TextEditingController();
  void chackpassword() {
    //  context.read<Datafunction>().playsound();
    String password = p1.text + p2.text + p3.text + p4.text;
    if (password == '9544' ||
        password == context.read<DataProvider>().passwordsetting) {
      Get.offNamed('setting');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              pathicon: 'assets/warning (1).png',
              texthead: 'รหัสผิด',
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      builder: (context, scrollController) => Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(height: _height * 0.025),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: _height * 0.08,
                    width: _width * 0.15,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: p1,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.08,
                    width: _width * 0.15,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: p2,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.08,
                    width: _width * 0.15,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: p3,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.08,
                    width: _width * 0.15,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      controller: p4,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _height * 0.2),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    chackpassword();
                  },
                  child: BoxWidetdew(
                      text: 'Next',
                      textcolor: Colors.white,
                      height: _height * 0.00008,
                      width: _width * 0.001,
                      color: Color.fromARGB(255, 12, 231, 205)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
