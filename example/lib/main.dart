import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';

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
    late String baseURI;
    if (kReleaseMode) {
      // Use here your release base uri for your app (without #!)
      // Example:
      // baseURI = 'https://MyFlutterApp.com';
    } else {
      baseURI = 'http://localhost:${Uri.base.port}';
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: UnityView(
        onCreated: (controller) => onUnityViewCreated(controller),
        onReattached: (controller) => onUnityViewReattached,
        onMessage: (_, message) => onUnityViewMessage(message),
        webUrl: '$baseURI/unity/index.html',
      ),
    );
  }

  void onUnityViewCreated(UnityViewController? controller) {
    print('onUnityViewCreated');

    controller?.send(
      'Cube',
      'SetRotationSpeed',
      '30',
    );
  }

  void onUnityViewReattached(UnityViewController? controller) {
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(String? message) {
    print('onUnityViewMessage');

    print(message);
  }
}
