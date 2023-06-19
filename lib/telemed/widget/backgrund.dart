import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';

class BackGrund extends StatefulWidget {
  const BackGrund({super.key});

  @override
  State<BackGrund> createState() => _BackGrundState();
}

class _BackGrundState extends State<BackGrund> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return _height > _width
        ? Container(
            width: _width,
            height: _height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: _height * 0.2,
                  width: _width,
                  child: SvgPicture.asset(
                    'assets/backgrund/backgrund.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: _width,
            height: _height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: _height * 0.4,
                  width: _width,
                  child: SvgPicture.asset(
                    'assets/backgrund/backgrund.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          );
  }
}
