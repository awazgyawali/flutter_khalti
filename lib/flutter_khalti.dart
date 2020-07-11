import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterKhalti {
  static const MethodChannel _channel = const MethodChannel('flutter_khalti');
  final String publicKey, urlSchemeIOS;
  @deprecated
  String _productId, _productName, _productUrl;
  @deprecated
  double _amount;
  @deprecated
  Map<String, String> customData;
  List<KhaltiPaymentPreference> paymentPreferences;

  /// Configure the payment gateway
  FlutterKhalti.configure({
    @required this.publicKey,
    @required this.urlSchemeIOS,
    this.paymentPreferences = const [
      KhaltiPaymentPreference.KHALTI,
      KhaltiPaymentPreference.CONNECT_IPS,
      KhaltiPaymentPreference.MOBILE_BANKING,
      KhaltiPaymentPreference.EBANKING,
      KhaltiPaymentPreference.SCT,
    ],
  });

  void startPayment({
    KhaltiProduct product,
    Function(Map) onSuccess,
    Function(Map) onFaliure,
  }) async {
    _channel.invokeMethod("khalti#startPayment", {
      "publicKey": publicKey,
      "product": product.toMap(),
      "urlSchemeIOS": urlSchemeIOS,
      "paymentPreferences": (product.paymentPreferences ?? paymentPreferences)
          .map((e) => _paymentPreferencesString[e.index])
          .toList(),
    });
    _listenToPaymentResponse(onSuccess, onFaliure);
  }

  /// Depricated, use `FlutterKhalti.configure` instead
  @deprecated
  FlutterKhalti({
    @required String publicKey,
    @required String productId,
    @required String productName,
    @required String urlSchemeIOS,
    @required double amount,
    @required List<KhaltiPaymentPreference> paymentPreferences,
    String productUrl = "",
    Map<String, String> customData = const {},
  })  : this.publicKey = publicKey,
        this._productId = productId,
        this._productName = productName,
        this._productUrl = productUrl,
        this.urlSchemeIOS = urlSchemeIOS,
        this._amount = amount,
        this.paymentPreferences = paymentPreferences,
        this.customData = customData;

  /// Depricated, use `FlutterKhalti.startPayment` instead
  @deprecated
  initPayment({Function onSuccess, Function onError}) {
    _channel.invokeMethod("khalti#start", {
      "publicKey": publicKey,
      "productId": _productId,
      "productName": _productName,
      "productUrl": _productUrl,
      "urlSchemeIOS": urlSchemeIOS,
      "amount": _amount,
      "paymentPreferences": paymentPreferences
          .map((e) => _paymentPreferencesString[e.index])
          .toList(),
      "customData": customData,
    });
    _listenToResponse(onSuccess, onError);
  }

  _listenToResponse(Function onSuccess, Function onError) {
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "khalti#success":
          onSuccess(call.arguments);
          break;
        case "khalti#error":
          onError(call.arguments);
          break;
        case "khalti#paymentSuccess":
          onSuccess(call.arguments);
          break;
        case "khalti#paymentError":
          onError(call.arguments);
          break;
        default:
      }
    });
  }

  _listenToPaymentResponse(Function onSuccess, Function onError) {
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "khalti#paymentSuccess":
          onSuccess(call.arguments);
          break;
        case "khalti#paymentError":
          onError(call.arguments);
          break;
        default:
      }
    });
  }
}

List<String> _paymentPreferencesString = [
  "khalti",
  "ebanking",
  "mobilecheckout",
  "connectips",
  "sct"
];

class KhaltiProduct {
  // The id of the product
  final String id,

      /// The name of the product
      name,

      /// The url of the product
      url;

  /// The amount of the product in paisa
  final double amount;

  /// If specified, the configuration from the `config` is ignored but not overridden
  final List<KhaltiPaymentPreference> paymentPreferences;

  /// Custom data attached to the payment
  final Map<String, String> customData;

  KhaltiProduct({
    // The id of the product
    @required this.id,

    /// The name of the product
    @required this.name,

    /// The amount of the product in paisa
    @required this.amount,

    /// If specified, the configuration from the `config` is ignored but not overridden
    this.paymentPreferences,

    /// The url of the product
    this.url = "",

    /// Custom data attached to the payment
    this.customData = const {},
  });

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "amount": amount,
      "customData": customData,
    };
  }
}

enum KhaltiPaymentPreference {
  KHALTI,
  EBANKING,
  MOBILE_BANKING,
  CONNECT_IPS,
  SCT,
}
