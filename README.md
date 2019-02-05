# flutter_khalti

Khalti SDK for flutter apps. Khalti Merchant can use this library to integrate the payment system in their system.

# Setup

## Android
No change is required, works out of the box.

## IOS
You have to add URL scheme to the project and send it as a parameter to the FlutterKhalti class.

//todo add url example

# How to use

```
    FlutterKhalti(
      "your_public_key", //your public key
      "productId",
      "productName",
      "productUrl",
      12121, //amount in paisa
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
        print(data); 
      },
    );
```

