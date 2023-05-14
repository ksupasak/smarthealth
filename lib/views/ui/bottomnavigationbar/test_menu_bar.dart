import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/views/ui/bottomnavigationbar/popupbar/popupsetting.dart';

class TestMenuBar extends StatefulWidget {
  const TestMenuBar({super.key});

  @override
  State<TestMenuBar> createState() => _TestMenuBarState();
}

class _TestMenuBarState extends State<TestMenuBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<Datafunction>().playsound();
          //Get.toNamed('test_page');
          Get.toNamed('printqueue');
        },
        child: Image.asset('assets/doctor.png'));
  }
}
