//
//  ContentView.swift
//  HeartTracker
//
//  Created by Taewon Yoon on 9/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(WatchConnectivity.self) var watchConnectivity
    
    var body: some View {
        VStack {
            WaveformView(heartRates: watchConnectivity.heartRates.map { $0.hr })
//            List(watchConnectivity.heartRates, id: \.id) { hr in
//                Text("\(hr.hr)")
//                    .padding()
//                
//            }
        }
        .padding()
    }
}

struct WaveformView: Shape {
    var heartRates: [Int]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard heartRates.count > 1 else { return path }

        let widthPerPoint = rect.width / CGFloat(heartRates.count - 1)
        let heightFactor = rect.height / CGFloat(heartRates.max() ?? 1)

        path.move(to: CGPoint(x: 0, y: rect.height / 2))

        for index in heartRates.indices {
            let x = CGFloat(index) * widthPerPoint
            let y = rect.height - CGFloat(heartRates[index]) * heightFactor
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}

#Preview {
    ContentView()
}
