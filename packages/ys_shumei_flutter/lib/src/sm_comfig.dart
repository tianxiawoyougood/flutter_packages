import 'package:flutter/material.dart';

class ShuMeiConfig {
  String organization;
  String appId;
  Function(String, dynamic)? callback;
  double width;
  int borderRadius;
  bool passState = false;

  ShuMeiConfig(
      {required this.organization,
      this.width = 320,
      this.borderRadius = 0,
      this.appId = "default",
      this.callback});
}
