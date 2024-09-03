//
//  WatchConnectivity.swift
//  HeartTracker
//
//  Created by Taewon Yoon on 9/4/24.
//

import Foundation
import WatchConnectivity

class iOSWatchOS: NSObject {

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
}

extension iOSWatchOS: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
