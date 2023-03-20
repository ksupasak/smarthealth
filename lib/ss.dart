import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class gg extends StatefulWidget {
  const gg({super.key});

  @override
  State<gg> createState() => _ggState();
}

class _ggState extends State<gg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            color: Colors.amber,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
              ),
            )),
      ),
    );
  }
}
