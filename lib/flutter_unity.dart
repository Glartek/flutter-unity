import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget_web/flutter_unity_widget_web.dart';

class UnityViewController {
  UnityViewController._(
    UnityView view,
    int id, {
    UnityWebController? webController,
  })  : _view = view,
        _webController = webController,
        _channel = MethodChannel('unity_view_$id') {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  UnityView _view;
  UnityWebController? _webController;
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
    if (kIsWeb) {
      _webController?.sendDataToUnity(
          gameObject: gameObjectName, method: methodName, data: message);
    } else {
      _channel.invokeMethod('send', {
        'gameObjectName': gameObjectName,
        'methodName': methodName,
        'message': message,
      });
    }
  }
}

typedef void UnityViewCreatedCallback(
  UnityViewController? controller,
);
typedef void UnityViewReattachedCallback(
  UnityViewController controller,
);
typedef void UnityViewMessageCallback(
  UnityViewController? controller,
  String? message,
);

class UnityView extends StatefulWidget {
  const UnityView({
    Key? key,
    this.onCreated,
    this.onReattached,
    this.onMessage,
    this.webUrl,
  }) : super(key: key);

  final UnityViewCreatedCallback? onCreated;
  final UnityViewReattachedCallback? onReattached;
  final UnityViewMessageCallback? onMessage;
  final String? webUrl;

  @override
  _UnityViewState createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> {
  UnityViewController? controller;
  UnityWebController? webController;

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
      controller?._channel.invokeMethod('dispose');
    }
    controller?._channel.setMethodCallHandler(null);
    // Disposing web leads to unwanted errors
    // webController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      assert(widget.webUrl != null,
          'The webUrl cannot be null if you want Unity WebGL to work on Flutter Web. Please add the argument webUrl.');

      return UnityWebWidget(
        url: widget.webUrl!,
        onUnityLoaded: (unityWebController) => onPlatformViewCreated(
          0,
          unityWebController: unityWebController,
        ),
        listenMessageFromUnity: (message) => widget.onMessage!(null, message),
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'unity_view',
          onPlatformViewCreated: onPlatformViewCreated,
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'unity_view',
          onPlatformViewCreated: onPlatformViewCreated,
        );
      default:
        throw UnsupportedError('Unsupported platform: $defaultTargetPlatform');
    }
  }

  void onPlatformViewCreated(
    int id, {
    UnityWebController? unityWebController,
  }) {
    controller = UnityViewController._(
      widget,
      id,
      webController: webController,
    );
    if (unityWebController != null) {
      webController = unityWebController;
    }
    if (widget.onCreated != null) {
      widget.onCreated!(controller);
    }
  }
}
