import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity/web/unity_web_controller.dart';
import 'package:flutter_unity/web/unity_web_widget.dart';

class UnityViewController {
  UnityViewController._(
    UnityView view,
    int id,
    UnityWebController? webController,
  )   : _view = view,
        _webController = webController,
        _channel = MethodChannel('unity_view_$id') {
    if (!kIsWeb) {
      _channel.setMethodCallHandler(_methodCallHandler);
    }
  }

  UnityView _view;
  final MethodChannel _channel;
  final UnityWebController? _webController;

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onUnityViewReattached':
        if (_view.onReattached != null) {
          _view.onReattached!(this);
        }
        return null;
      case 'onUnityViewMessage':
        _view.onMessage(this, call.arguments);
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
        gameObject: gameObjectName,
        method: methodName,
        data: message,
      );
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
    required this.onCreated,
    required this.onMessage,
    this.onReattached,
    this.webUrl,
  }) : super(key: key);

  final UnityViewCreatedCallback onCreated;
  final UnityViewReattachedCallback? onReattached;
  final UnityViewMessageCallback onMessage;
  final String? webUrl;

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
      controller?._channel.invokeMethod('dispose');
    }
    controller?._channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      assert(widget.webUrl != null,
          'webUrl argument is necessary for Unity WebGL! Please add a webUrl to UnityView.');

      return UnityWebWidget(
        url: widget.webUrl!,
        listenMessageFromUnity: (message) => widget.onMessage(null, message),
        onUnityLoaded: (controller) => onPlatformViewCreated(
          0,
          webController: controller,
        ),
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
    UnityWebController? webController,
  }) {
    controller = UnityViewController._(widget, id, webController);
    widget.onCreated(controller);
  }
}
