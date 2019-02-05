
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