import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let liveActivityService: ParkingLiveActivityService = .shared
    
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
              self.startLiveActivity()
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
            currentDuration: "Тривалість",
            remainingTime: "Залишилось",
            totalDuration: "Загалом",
            parkingEndedTitle: "Паркування завершено",
            parkingEndedSubtitle: "Дякуємо, що скористались сервісом!"
        )
        
        let model = ParkingLiveActivityModel(
            zoneId: "2.371",
            licensePlate: "AA627KT",
            price: .init(amount: 1.5, currencySymbol: "€"),
            startDate: .now,
            endDate: .now.addingTimeInterval(140),
            labels: labels
        )
        
        liveActivityService.sync(with: model)
    }
    
    private func endLiveActivity(for zoneId: String) {
        liveActivityService.end(for: zoneId)
    }
}
