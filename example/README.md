
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