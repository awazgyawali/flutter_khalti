import Flutter
import Khalti
import UIKit

public class SwiftFlutterKhaltiPlugin: NSObject, FlutterPlugin, KhaltiPayDelegate {
    
    public var viewController: UIViewController
    public var channel:FlutterMethodChannel
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_khalti", binaryMessenger: registrar.messenger())
        
        let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!;
        let instance = SwiftFlutterKhaltiPlugin(viewController: viewController, channel
            : channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(viewController:UIViewController, channel:FlutterMethodChannel) {
        self.viewController = viewController
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "khalti#startPayment":
            startPayment(call: call)
            result(true)
            break;
        default:
            break;
        }
    }
    
    func startPayment(call: FlutterMethodCall){
        let message = call.arguments as? Dictionary<String,Any>
        let publicKey =  message!["publicKey"] as? String
        let khaltiUrlScheme:String = toString(data: message!["urlSchemeIOS"]!)
        let product = message!["product"] as? Dictionary<String,Any>
        let paymentPreferences = message!["paymentPreferences"] as? [String]
        
        let _CONFIG:Config = Config(
            publicKey: toString(data: publicKey!),
            amount: toInt(json: product!["amount"]!),
            productId: toString(data: product!["id"]!),
            productName: toString(data: product!["name"]!),
            productUrl:toString(data: product!["url"]!),
            additionalData: (product!["customData"] as! Dictionary<String, String>),
            ebankingPayment: paymentPreferences?.contains("ebanking") ?? true
        );
        
        Khalti.shared.appUrlScheme = khaltiUrlScheme
        
        Khalti.present(caller: viewController, with: _CONFIG, delegate: self)
    }
    
    public func onCheckOutSuccess(data: Dictionary<String, Any>) {
        channel.invokeMethod("khalti#paymentSuccess",arguments:  data)
    }
    
    public func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        var d = data ?? Dictionary<String, Any>()
        d.updateValue(message, forKey: "message")
        d.updateValue(action, forKey: "action")
        channel.invokeMethod("khalti#paymentError",arguments: data)
    }
    
    func toString(data:Any) -> String{
        return data as? String ?? ""
    }
    
    func toInt(json:Any) -> Int{
        return json as! Int
    }
}
