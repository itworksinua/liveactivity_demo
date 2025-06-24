//
//  MyAppWidgetLiveActivity.swift
//  MyAppWidget
//
//  Created by Admin on 24.06.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState
  public struct ContentState: Codable, Hashable {
      
      var emoji: String
  }

  var id = UUID()
    var name: String
}

//struct MyAppWidgetAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var emoji: String
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}

let sharedDefault = UserDefaults(suiteName: "group.com.itworksinua.liveactivity")!

struct MyAppWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            let myVariableFromFlutter = sharedDefault.string(forKey: context.attributes.prefixedKey("myVariableFromFlutter"))!

            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivitiesAppAttributes {
    fileprivate static var preview: LiveActivitiesAppAttributes {
        LiveActivitiesAppAttributes(name: "World")
    }
    func prefixedKey(_ key: String) -> String {
      return "\(id)_\(key)"
    }
}

extension LiveActivitiesAppAttributes.ContentState {
    fileprivate static var smiley: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LiveActivitiesAppAttributes.ContentState {
         LiveActivitiesAppAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LiveActivitiesAppAttributes.preview) {
   MyAppWidgetLiveActivity()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState.smiley
    LiveActivitiesAppAttributes.ContentState.starEyes
}
