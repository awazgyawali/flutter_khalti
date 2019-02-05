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
```

