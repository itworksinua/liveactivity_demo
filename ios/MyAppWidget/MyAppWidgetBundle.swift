//
//  MyAppWidgetBundle.swift
//  MyAppWidget
//
//  Created by Admin on 24.06.2025.
//

import WidgetKit
import SwiftUI

@main
struct MyAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyAppWidget()
        MyAppWidgetControl()
        MyAppWidgetLiveActivity()
    }
}
