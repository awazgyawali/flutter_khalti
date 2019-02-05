import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterKhalti {
  static const MethodChannel channel = const MethodChannel('flutter_khalti');

  String _publicKey, _productId, _productName, _productUrl, _urlSchemeIOS;
  double _amount;
  Map<String, String> _customData;

  FlutterKhalti({
    @required String publicKey,
    @required String productId ,
    @required String productName,
    String productUrl = "",
    @required String urlSchemeIOS,
    @required double amount,
    Map<String, String> customData = const {},
  })  : this._publicKey = publicKey,
        this._productId = productId,
        this._productName = productName,
        this._productUrl = productUrl,
        this._urlSchemeIOS = urlSchemeIOS,
        this._amount = amount,
        this._customData = customData;

  initPayment({Function onSuccess, Function onError}) {
    channel.invokeMethod("khalti#start", {
      "publicKey": _publicKey,
      "productId": _productId,
      "productName": _productName,
      "productUrl": _productUrl,
      "urlSchemeIOS": _urlSchemeIOS,
      "amount": _amount,
      "customData": _customData,
    });
    _listenToResponse(onSuccess, onError);
  }

  _listenToResponse(Function onSuccess, Function onError) {
    channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "khalti#success":
          onSuccess(call.arguments);
          break;
        case "khalti#error":
          onError(call.arguments);
          break;
        default:
      }
    });
  }
}
