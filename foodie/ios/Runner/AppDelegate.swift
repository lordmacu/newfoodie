import UIKit
import Flutter
import GoogleMaps
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    GMSServices.provideAPIKey("AIzaSyAuNE44H_HuDLu8iB8u7Xfdipm-Cy-Qogo")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @available(iOS 9.0, *)
  override  func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return ApplicationDelegate.shared.application(application,  open: url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
  }

    // para iOS menor a 9.0
  override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return ApplicationDelegate.shared.application(application,open: url as URL!,sourceApplication: sourceApplication,annotation: annotation)
  }
}
