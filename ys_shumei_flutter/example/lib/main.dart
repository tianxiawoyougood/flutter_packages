import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ys_shumei_flutter/ys_shumei_flutter.dart';

// typedef QRViewCreatedCallback = void Function(ShuMeiViewController);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }


  // static const MethodChannel methodChannel = MethodChannel('method_channel');

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context){
            return TextButton(
              onPressed: (){
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                     // return SmWebView(config: ShuMeiConfig(organization: "KMOKbRvihXmetHEwlp5g"),);
                      return SizedBox();
                    }));
              },
              child: Text('弹出滑块弹窗'),
            );
          },
        ),
      ),
    );
  }


}


