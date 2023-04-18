import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Popup extends StatefulWidget {
  Popup(
      {super.key, this.texthead, this.textbody, this.pathicon, this.buttonbar});
  var texthead;
  var textbody;
  var pathicon;
  var buttonbar;
  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return AlertDialog(
      icon: widget.pathicon == null
          ? null
          : Image.asset(
              "${widget.pathicon}",
              width: _width * 0.05,
              height: _height * 0.2,
            ),
      title: widget.texthead == null ? null : Text("${widget.texthead}"),
      content: widget.textbody == null ? null : Text("${widget.textbody}"),
      actions: widget.buttonbar == null ? null : widget.buttonbar,
    );
  }
}
