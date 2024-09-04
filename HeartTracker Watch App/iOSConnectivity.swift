//
//  iOSConnectivity.swift
//  HeartTracker Watch App
//
//  Created by Taewon Yoon on 9/4/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class iOSConnectivity: NSObject {
    @Environment(HeartTracker.self) var heartTracker
    
    let session = WCSession.default
    
    func sendHeartRate(heartRate: Int, date: Date) {
        if WCSessionActivationState.activated == .activated {
            do {
                try session.updateApplicationContext(["HR":heartRate, "date":date])
            } catch {
                print("HR 전송실패")
            }
        }
    }
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
        
    }
}

extension iOSConnectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("session activation Did Complete: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
    
    
}
