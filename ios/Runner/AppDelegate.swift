import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let liveActivityService: ParkingLiveActivityService = .shared
    private let tokenSyncService: TokenSyncService = .shared
    
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
          if call.method == "startActivity" {
              self.startLiveActivity()
              result(nil)
              return
          }
          
          if call.method == "sendRequestDetails" {
              if let arg = call.arguments as? [String : Any],
                 let authorization = arg["authorization"] as? String,
                 let url = arg["url"] as? String {
                  self.configureTokenSync(authorization: authorization, url: url)
              }
              result(nil)
              return
          }
          
          result(FlutterMethodNotImplemented)
      })
//      self.injectTestParkingLabels() // TO test uncomment this line
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func startLiveActivity() {
        let labels: ParkingLiveActivityAttributes.Labels = .init(
            start: "Початок",
            ends: "Кінець",
            ended: "Кінець",
            parkingStarts: "Паркування починається"
        )
        
        let state: ParkingLiveActivityAttributes.State = .reservation(
            start: .now,
            end: .now.addingTimeInterval(140) ///Optional
        )
        
        let model = ParkingLiveActivityModel(
            zoneId: "2.371",
            licensePlate: "AA627KT",
            state: state,
            labels: labels
        )
        
        liveActivityService.sync(with: model)
    }
    
    private func endLiveActivity(for zoneId: String) {
        liveActivityService.end(for: zoneId)
    }
    
    private func endAllLiveActivity() {
        liveActivityService.endAll()
    }
    
    private func configureTokenSync(authorization: String, url: String) {
        tokenSyncService.configure(authorization: authorization, url: url)
        tokenSyncService.syncAllTokens()
        print("🔧 Token sync configured and existing tokens synced")
    }
}
