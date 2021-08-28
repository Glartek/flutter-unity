import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnityViewController {
  UnityViewController._(
    UnityView view,
    int id,
  )   : _view = view,
        _channel = MethodChannel('unity_view_$id') {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  UnityView _view;
  final MethodChannel _channel;

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onUnityViewReattached':
        if (_view.onReattached != null) {
          _view.onReattached!(this);
        }
        return null;
      case 'onUnityViewMessage':
        if (_view.onMessage != null) {
          _view.onMessage!(this, call.arguments);
        }
        return null;
      default:
        throw UnimplementedError('Unimplemented method: ${call.method}');
    }
  }

  void pause() {
    _channel.invokeMethod('pause');
  }

  void resume() {
    _channel.invokeMethod('resume');
  }

  void send(
    String gameObjectName,
    String methodName,
    String message,
  ) {
    _channel.invokeMethod('send', {
      'gameObjectName': gameObjectName,
      'methodName': methodName,
      'message': message,
    });
  }
}

typedef void UnityViewCreatedCallback(
  UnityViewController? controller,
);
typedef void UnityViewReattachedCallback(
  UnityViewController controller,
);
typedef void UnityViewMessageCallback(
  UnityViewController controller,
  String? message,
);

class UnityView extends StatefulWidget {
  const UnityView({
    Key? key,
    this.onCreated,
    this.onReattached,
    this.onMessage,
  }) : super(key: key);

  final UnityViewCreatedCallback? onCreated;
  final UnityViewReattachedCallback? onReattached;
  final UnityViewMessageCallback? onMessage;

  @override
  _UnityViewState createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> {
  UnityViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(UnityView oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller?._view = widget;
  }

  @override
  void dispose() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      controller?._channel?.invokeMethod('dispose');
    }
    controller?._channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'unity_view',
          onPlatformViewCreated: onPlatformViewCreated,
        );
        break;
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'unity_view',
          onPlatformViewCreated: onPlatformViewCreated,
        );
        break;
      default:
        throw UnsupportedError('Unsupported platform: $defaultTargetPlatform');
    }
  }

  void onPlatformViewCreated(int id) {
    controller = UnityViewController._(widget, id);
    if (widget.onCreated != null) {
      widget.onCreated!(controller);
    }
  }
}
