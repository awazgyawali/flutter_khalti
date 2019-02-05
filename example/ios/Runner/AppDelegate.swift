import UIKit
import Khalti
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Khalti.shared.action(with: url)
        return Khalti.shared.defaultAction()
    }
}
