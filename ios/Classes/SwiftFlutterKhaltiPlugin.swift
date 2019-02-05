import Flutter
import Khalti
import UIKit

public class SwiftFlutterKhaltiPlugin: NSObject, FlutterPlugin, KhaltiPayDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_khalti", binaryMessenger: registrar.messenger())
    
    let viewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!;
    let instance = SwiftFlutterKhaltiPlugin(viewController: viewController)
    

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

     public init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
   
    public var viewController: UIViewController
    
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
        let khaltiUrlScheme:String = "KhaltiPayFlutterExampleScheme"
        var arguments = args as? [String:Any];
        let _CONFIG:Config = Config(publicKey: toString(data: arguments!["publicKey"]), amount: toInt(json: arguments!["amount"]), productId: toString(data: arguments!["productId"]), productName: toString(data: arguments!["productName"]), productUrl:toString(data: arguments!["productUrl"]))
        Khalti.shared.appUrlScheme = khaltiUrlScheme
         Khalti.present(caller: viewController, with: _CONFIG, delegate: self)
        
    }
   public func onCheckOutSuccess(data: Dictionary<String, Any>) {
        print(data)
        print("Oh there is success message received")
    }
    public func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        print(action)
        print(message)
        print("Oh there occure error in payment")
    }
    func toString(data:Any) -> String{
        return String(describing: data);
    }
    
    func toInt(json:Any) -> Int{
        return json as! Int
    }
}
//,additionalData: arguments["customData"]
