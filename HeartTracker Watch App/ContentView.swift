//
//  ContentView.swift
//  HeartTracker Watch App
//
//  Created by Taewon Yoon on 9/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(HeartTracker.self) var tracker
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            tracker.autorizeHealthKit()
            tracker.startHeartRateQuery()
        }
    }
}

#Preview {
    ContentView()
}
