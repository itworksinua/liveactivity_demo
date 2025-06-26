import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let nativeChannel = FlutterMethodChannel(name: "com.itworksinua.liveactivityDemo/activity",
                                               binaryMessenger: controller.binaryMessenger)
      nativeChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          // This method is invoked on the UI thread.
          // Handle battery messages.
          if call.method == "startActivity"  {
              self.injectTestParkingLabels()
              result(nil)
              return
          }
          
          
          result(FlutterMethodNotImplemented)
      })
//      self.injectTestParkingLabels() // TO test uncomment this line
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func injectTestParkingLabels(prefix: String = "live_activity") {
        let sharedDefault = UserDefaults(suiteName: "group.com.itworksinua.liveactivity")!
        
        sharedDefault.set("Тривалість", forKey: "\(prefix)_current_duration")
        sharedDefault.set("Залишилось", forKey: "\(prefix)_remaining_time")
        sharedDefault.set("Загалом", forKey: "\(prefix)_total_duration")
        startLiveActivity()
        
    }
    
    private func startLiveActivity() {
        let model = ParkingLiveActivityModel(
            zoneId: "2.371",
            licensePlate: "AA627KT",
            price: 1.5,
            startDate: .now,
            endDate: .now.addingTimeInterval(140) // 1 min 20 sec
        )
        
        ParkingLiveActivityService.shared.sync(with: model)
    }
    
    
}
