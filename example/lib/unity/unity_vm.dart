import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';

class UnityWidget {
  static late UnityViewController _unityController;

  static Widget buildUnityWidget({
    required void Function(dynamic message) onMessage,
    required void Function(dynamic controller) onUnityViewCreated,
    void Function(dynamic)? onReattached,
  }) {
    return UnityView(
      onCreated: (controller) => onUnityViewCreated(controller),
      onReattached: onReattached,
      onMessage: (_, message) => onMessage(message),
    );
  }

  UnityViewController get controller => _unityController;
}
