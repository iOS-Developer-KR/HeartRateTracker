//
//  WatchConnectivity.swift
//  HeartTracker
//
//  Created by Taewon Yoon on 9/4/24.
//

import Foundation
import WatchConnectivity



@Observable
class WatchConnectivity: NSObject {

    var isActivated: Bool = false
    let session = WCSession.default
    var heartRates: [HeartRate] = []

    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    // 애플워치와 패어링이 되었는지 여부
    func checkIsPaired() -> Bool {
        return session.isPaired
    }
    
    // 애플워치에 앱이 설치 되었는지 여부
    func isWatchAppInstalled() -> Bool {
        return session.isWatchAppInstalled
    }
    
    func receiveHeartRateFromWatch() {
        
    }
}


extension WatchConnectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        switch activationState {
        case .activated:
            print("WCSession activated successfully")
        case .inactive:
            print("Unable to activate the WCSession. Error: \(error?.localizedDescription ?? "--")")
        case .notActivated:
            print("Unexpected .notActivated state received after trying to activate the WCSession")
        @unknown default:
            print("Unexpected state received after trying to activate the WCSession")
        }    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session Did Become Inactivated")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session Did Become Deactivated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        let hr = applicationContext["HR"] as! Int
        let date = applicationContext["date"] as! Date
        
        if heartRates.count > 10 { heartRates.removeLast() }
        heartRates.append(HeartRate(hr: hr, date: date))
    }
}
