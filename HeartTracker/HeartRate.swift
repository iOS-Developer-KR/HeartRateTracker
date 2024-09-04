//
//  HeartRate.swift
//  HeartTracker
//
//  Created by Taewon Yoon on 9/4/24.
//

import Foundation

struct HeartRate: Identifiable {
    let id = UUID()
    var hr: Int
    var date: Date
}
