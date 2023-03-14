import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sm_view_controller.dart';

class SmWebView extends StatefulWidget {
  final double width;
  final ShuMeiViewController controller;

  const SmWebView({Key? key, this.width = 320, required this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SmWebViewState();
  }
}

class _SmWebViewState extends State<SmWebView> {
  final viewIdentifier = 'sample_view';

  @override
  void initState() {
    super.initState();
    widget.controller.config.width = widget.width;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidSmCaptchaWidget(
            key: widget.key, controller: widget.controller, viewType: viewIdentifier);
      case TargetPlatform.iOS:
        return IOSSmCaptchaWidget(
            key: widget.key, controller: widget.controller, viewType: viewIdentifier);
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}

class AndroidSmCaptchaWidget extends StatefulWidget {
  final String viewType;
  final ShuMeiViewController controller;

  const AndroidSmCaptchaWidget(
      {Key? key, required this.viewType, required this.controller})
      : super(key: key);

  @override
  State<AndroidSmCaptchaWidget> createState() => _AndroidSmCaptchaWidgetState();
}

class _AndroidSmCaptchaWidgetState extends State<AndroidSmCaptchaWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.controller.config.width,
        height: widget.controller.config.width / 3 * 2,
        child: AndroidView(
          layoutDirection: Directionality.maybeOf(context) ?? TextDirection.rtl,
          viewType: widget.viewType,
          onPlatformViewCreated: widget.controller.platformViewCreated,
        ),
      ),
    );
  }
}

class IOSSmCaptchaWidget extends StatefulWidget {
  final String viewType;
  final ShuMeiViewController controller;

  const IOSSmCaptchaWidget(
      {Key? key, required this.controller, required this.viewType})
      : super(key: key);

  @override
  State<IOSSmCaptchaWidget> createState() => _IOSSmCaptchaWidgetState();
}

class _IOSSmCaptchaWidgetState extends State<IOSSmCaptchaWidget> {

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.controller.config.width,
        height: widget.controller.config.width / 3 * 2,
        child: UiKitView(
          viewType: widget.viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: widget.controller.platformViewCreated,
        ),
      ),
    );
  }
}
