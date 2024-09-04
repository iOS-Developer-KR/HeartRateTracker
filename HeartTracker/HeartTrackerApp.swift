//
//  HeartTrackerApp.swift
//  HeartTracker
//
//  Created by Taewon Yoon on 9/2/24.
//

import SwiftUI

@main
struct HeartTrackerApp: App {
    
    @State private var watchConnectivity = WatchConnectivity()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(watchConnectivity)
        }
    }
}
