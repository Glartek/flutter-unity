import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class UrlLauncherPluginWeb {
  static void registerWith(Registrar registrar, int id) {
    final MethodChannel channel = MethodChannel(
        'unity_view_$id',
        const StandardMethodCodec(),
        registrar);
    final UrlLauncherPluginWeb instance = UrlLauncherPluginWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'dispose':
        return _dispose();
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_disposeer plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  void _dispose() {}
}
