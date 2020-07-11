# flutter_khalti

Khalti SDK for flutter apps. Khalti Merchant can use this library to integrate the payment system in their system.

# Setup

## Android

No change is required, works out of the box.

## IOS

You have to add URL scheme to the project and send it as a parameter to the FlutterKhalti class as shown in the example code below.

![Khalti scheme setup overview](https://github.com/awazgyawali/flutter_khalti/blob/master/images/url_scheme.png)

# How to use

```
    FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
      publicKey: "test_public_key_eacadfb91994475d8bebfa577b0bca68",
      urlSchemeIOS: "KhaltiPayFlutterExampleScheme",
    );

    KhaltiProduct product = KhaltiProduct(
      id: "test",
      amount: 1000,
      name: "Hello Product",
    );

    _flutterKhalti.startPayment(
      product: product,
      onSuccess: (data) {
        print("Success message here");
      },
      onFaliure: (error) {
        print("Error message here");
      },
    );
```
