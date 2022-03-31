import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';
import 'package:flutter_unity_widget_web/flutter_unity_widget_web.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UnityViewPage()));
          },
          child: Text('Test'),
        ),
      ),
    );
  }
}

class UnityViewPage extends StatefulWidget {
  @override
  _UnityViewPageState createState() => _UnityViewPageState();
}

class _UnityViewPageState extends State<UnityViewPage> {
  UnityViewController? unityViewController;
  UnityWebController? unityWebController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildUnityWidget() {
    if (kIsWeb) {
      late String baseURI;
      if (kReleaseMode) {
        baseURI = 'https://myapp.com';
      } else {
        baseURI = 'http://localhost:${Uri.base.port}';
      }
      return UnityWebWidget(
        url: '$baseURI/unity/index.html',
        listenMessageFromUnity: onUnityViewMessage,
        onUnityLoaded: (webController) => onUnityViewCreated(
          webController: webController,
        ),
      );
    }
    return UnityView(
      onCreated: (controller) => onUnityViewCreated(controller: controller),
      onReattached: onUnityViewReattached,
      onMessage: (_, message) => onUnityViewMessage(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: buildUnityWidget(),
    );
  }

  void onUnityViewCreated({
    UnityViewController? controller,
    UnityWebController? webController,
  }) {
    print('onUnityViewCreated');

    unityViewController ??= controller;
    unityWebController ??= webController;

    if (kIsWeb) {
      webController?.sendDataToUnity(
        gameObject: 'Cube',
        method: 'SetRotationSpeed',
        data: '30',
      );
    } else {
      controller?.send(
        'Cube',
        'SetRotationSpeed',
        '30',
      );
    }
  }

  void onUnityViewReattached(UnityViewController controller) {
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(String? message) {
    print('onUnityViewMessage');

    print(message);
  }
}
