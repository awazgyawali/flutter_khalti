# flutter_khalti

Khalti SDK for flutter apps. Khalti Merchant can use this library to integrate the payment system in their system.


# How to use

```
    FlutterKhalti(
      "your_public_key",
      "productId",
      "productName",
      "productUrl",
      12121,
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