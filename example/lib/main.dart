import 'package:flutter/material.dart';

import 'package:flutter_khalti/flutter_khalti.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  _payViaKhalti() {
    FlutterKhalti(
      urlSchemeIOS: "KhaltiPayFlutterExampleScheme",
      publicKey: "test_public_key_eacadfb91994475d8bebfa577b0bca68",
      productId: "1233",
      productName: "Test 2",
      amount: 12121,
      customData: {
        "test": "asass",
      },
    ).initPayment(
      onSuccess: (data) {
        print("success");
        print(data);
      },
      onError: (error) {
        print("error");
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
            child: Text("Pay via khalti"),
            onPressed: () {
              _payViaKhalti();
            },
          ),
        ),
      ),
    );
  }
}
