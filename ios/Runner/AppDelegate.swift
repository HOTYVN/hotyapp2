import UIKit
import Flutter
import GoogleMaps
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
  if #available(iOS 10.0, *) {
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
  }
      
  GMSServices.provideAPIKey("AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs")
      GeneratedPluginRegistrant.register(with : self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
