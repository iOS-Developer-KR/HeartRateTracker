//
//  HeartTrackerApp.swift
//  HeartTracker Watch App
//
//  Created by Taewon Yoon on 9/2/24.
//

import SwiftUI

@main
struct HeartRateTrackerApp: App {
    @State private var tracker = HeartTacker()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(tracker)
        }
    }
}
