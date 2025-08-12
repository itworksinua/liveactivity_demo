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
          if call.method == "startActivity" {
              self.startLiveActivity()
              result(nil)
              return
          }
          
          if call.method == "getLiveActivityPushToken" {
              let token = LiveActivityTokenStorage.shared.getTokensForServer()
              result(token)
              return
          }
          
          if call.method == "sendRequestDetails" {
              if let arg = call.arguments as? [String : Any],
                 let authorization = arg["authorization"] as? String,
                 let url = arg["url"] as? String{
                  self.saveRequestDetails(authorization, url: url)
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
    
    func saveRequestDetails(_ authorization: String, url: String) {
        // save these two strings for later usage
    }
    
    // Call this method where the update token is received
    private func sendUpdateTokenToServer(_ token: String, url: String, authorization: String) {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        //refreshActivityToken
        let postData: [String: Any] = ["refreshActivityToken": "token"]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        } catch {
            print("Error creating JSON data: \(error)")
            return
        }
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response or status code.")
                    return
                }
                
                print("Response data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                
            } catch {
                print("Error during API call: \(error.localizedDescription)")
            }
        }
    }
}
