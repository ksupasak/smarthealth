import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:image/image.dart' as img;
import 'image_utils.dart';

import 'esm_printer.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:io';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}



class _TestPageState extends State<TestPage> {

ESMPrinter? printer;

@override
void initState(){

   printer = ESMPrinter([{'vendor_id':'1137','product_id':'85'}]);


}

void print() async{

    List<int> bytes = [];


// Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');

    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Test Print', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Product 1');
    bytes += generator.text('Product 2');

 final ByteData data = await rootBundle.load('assets/ic_launcher.png');
    if (data.lengthInBytes > 0) {
      final Uint8List imageBytes = data.buffer.asUint8List();
      // decode the bytes into an image
      final decodedImage = img.decodeImage(imageBytes)!;
      // Create a black bottom layer
      // Resize the image to a 130x? thumbnail (maintaining the aspect ratio).
      img.Image thumbnail = img.copyResize(decodedImage, height: 130);
      // creates a copy of the original image with set dimensions
      img.Image originalImg = img.copyResize(decodedImage, width: 380, height: 130);
      // fills the original image with a white background
      img.fill(originalImg, color: img.ColorRgb8(255, 255, 255));
      var padding = (originalImg.width - thumbnail.width) / 2;

      //insert the image inside the frame and center it
      drawImage(originalImg, thumbnail, dstX: padding.toInt());

      // convert image to grayscale
      var grayscaleImage = img.grayscale(originalImg);

      bytes += generator.feed(1);
      // bytes += generator.imageRaster(img.decodeImage(imageBytes)!, align: PosAlign.center);
      bytes += generator.imageRaster(grayscaleImage, align: PosAlign.center);
      bytes += generator.feed(1);
    }


    printer?.printEscPos(bytes, generator);
    
}


@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Pos Plugin Platform example app'),
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {

                                    print();
                                      // printer?.printTest();
                                   
                                  },
                            child: const Text("Connect", textAlign: TextAlign.center),
                          ),
                        ),
                      ]
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
    

}

}
