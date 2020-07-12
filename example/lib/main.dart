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

  _payViaKhalti() async {
    FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
      publicKey: "test_public_key_eacadfb91994475d8bebfa577b0bca68",
      urlSchemeIOS: "KhaltiPayFlutterExampleScheme",
      paymentPreferences: [
        KhaltiPaymentPreference.KHALTI,
      ],
    );

    KhaltiProduct product = KhaltiProduct(
      id: "test",
      amount: 1000,
      name: "Hello Product",
    );
    _flutterKhalti.startPayment(
      product: product,
      onSuccess: (data) {
        print("here");
      },
      onFaliure: (error) {
        print("sorry");
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
            onPressed: _payViaKhalti,
          ),
        ),
      ),
    );
  }
}
