import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ys_shumei_flutter/src/sm_comfig.dart';

class ShuMeiViewController {

  late final ShuMeiConfig _config;

   MethodChannel? _channel;


  platformViewCreated(int id) {
    _channel = MethodChannel('shumei_method_channel_$id');
    _config.callback = _config.callback ?? _defaultCallback;
    _channel?.setMethodCallHandler((call) async {
      if(_config.callback != null){
        _config.callback!(call.method, call.arguments);
      }
    });
    initSmCaptchaWebView();
  }

  ShuMeiConfig  get config => _config;

  ShuMeiViewController.method(ShuMeiConfig config) : _config = config;

  void _defaultCallback(String method, dynamic arguments) {
    switch (method) {
      case 'onError':
        break;
      case 'pass':
        break;
      case 'no_pass':
        break;
      case 'onReady':
        break;
    }
  }

  void destroySmCaptchaWebView(){
    _channel?.invokeMethod("destroySmCaptchaWebView");
  }

  void reload(){
    _channel?.invokeMethod("reload");
  }

  void dispose() async{
    _config.callback = null;
  }

  Future<void> initSmCaptchaWebView() async {
    Map<String, Object> map = {};
    map['borderRadius'] = _config.borderRadius;
    map['width'] = _config.width;
    map['organization'] = _config.organization;
    map['appId'] = _config.appId;
    String? result = await _channel?.invokeMethod("initSmCaptchaWebView", map);
    if(_config.callback != null){
      _config.callback!("invokeMethod", result);
    }

  }
}
