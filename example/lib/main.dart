import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';
import 'package:flutter_unity_example/unity/unity.dart';

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
  dynamic unityViewController;

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
      body: UnityWidget.buildUnityWidget(
        onMessage: (message) => onUnityViewMessage,
        onUnityViewCreated: (controller) => onUnityViewCreated,
        onReattached: (controller) => onUnityViewReattached,
      ),
    );
  }

  void onUnityViewCreated(
    dynamic controller,
  ) {
    print('onUnityViewCreated');

    unityViewController ??= controller;

    if (kIsWeb) {
      controller?.sendDataToUnity(
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
