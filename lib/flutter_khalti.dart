import 'package:flutter/services.dart';

class FlutterKhalti {
  static const MethodChannel _channel = const MethodChannel('flutter_khalti');
  late final String publicKey, urlSchemeIOS;

  List<KhaltiPaymentPreference> paymentPreferences;

  /// Configure the payment gateway
  FlutterKhalti.configure({
    required this.publicKey,
    required this.urlSchemeIOS,
    this.paymentPreferences = const [
      KhaltiPaymentPreference.KHALTI,
      KhaltiPaymentPreference.CONNECT_IPS,
      KhaltiPaymentPreference.MOBILE_BANKING,
      KhaltiPaymentPreference.EBANKING,
      KhaltiPaymentPreference.SCT,
    ],
  });

  void startPayment({
    required KhaltiProduct product,
    required Function(Map) onSuccess,
    required Function(Map) onFaliure,
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

  _listenToResponse(Function onSuccess, Function onError) {
    _channel.setMethodCallHandler((call) async {
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
    _channel.setMethodCallHandler((call) async {
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
  final List<KhaltiPaymentPreference>? paymentPreferences;

  /// Custom data attached to the payment
  final Map<String, String> customData;

  KhaltiProduct({
    // The id of the product
    required this.id,

    /// The name of the product
    required this.name,

    /// The amount of the product in paisa
    required this.amount,

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

/// Configuration for payment methods within khalti SDK
enum KhaltiPaymentPreference {
  /// Respected only on Android, iOS will show this option anyway
  KHALTI,

  /// Respected on both Android and iOS
  EBANKING,

  /// Respected on only Android, iOS SDK doesnt support it
  MOBILE_BANKING,

  /// Respected on only Android, iOS SDK doesnt support it
  CONNECT_IPS,

  /// Respected on only Android, iOS SDK doesnt support it
  SCT,
}
