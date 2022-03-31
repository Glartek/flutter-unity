import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_web/flutter_unity_widget_web.dart';

class UnityWidget {
  static late UnityWebController _unityController;

  static Widget buildUnityWidget({
    required void Function(dynamic message) onMessage,
    required void Function(dynamic controller) onUnityViewCreated,
    void Function(dynamic)? onReattached,
  }) {
    late String baseURI;
    if (kReleaseMode) {
      baseURI = 'https://myapp.com';
    } else {
      baseURI = 'http://localhost:${Uri.base.port}';
    }

    return UnityWebWidget(
      url: '$baseURI/unity/index.html',
      listenMessageFromUnity: onMessage,
      onUnityLoaded: (controller) {
        _unityController = controller;
        onUnityViewCreated(
          controller,
        );
      },
    );
  }

  UnityWebController get controller => _unityController;
}
