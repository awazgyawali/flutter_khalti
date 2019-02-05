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
        case "khalti#start":
            initPayment(args: call.arguments!)
            break;
        default:
            break;
        }
    }
    
    func initPayment(args:Any){
        var arguments = args as? [String:Any];
        
        let khaltiUrlScheme:String = toString(data: arguments!["urlSchemeIOS"])
        let _CONFIG:Config = Config(publicKey: toString(data: arguments!["publicKey"]), amount: toInt(json: arguments!["amount"]), productId: toString(data: arguments!["productId"]), productName: toString(data: arguments!["productName"]), productUrl:toString(data: arguments!["productUrl"]))
        
        Khalti.shared.appUrlScheme = khaltiUrlScheme
        Khalti.present(caller: viewController, with: _CONFIG, delegate: self)
        
    }
    
    public func onCheckOutSuccess(data: Dictionary<String, Any>) {
        channel.invokeMethod("khalti#success",arguments:  data)
    }
    
    public func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        var d = data!
        d.updateValue(message, forKey: "message")
        d.updateValue(action, forKey: "action")
        channel.invokeMethod("khalti#error",arguments: data)
    }
    
    func toString(data:Any) -> String{
        return data as? String ?? ""
    }
    
    func toInt(json:Any) -> Int{
        return json as! Int
    }
}
