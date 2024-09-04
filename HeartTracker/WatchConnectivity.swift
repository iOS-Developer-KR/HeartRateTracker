import WatchConnectivity
import SwiftUI

@Observable
class WatchConnectivity: NSObject {

    var isActivated: Bool = false
    let session = WCSession.default
    var heartRates: [HeartRate] = []
    var currentRate: HeartRate?
    private var timer: Timer? = nil

    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            startUpdating()
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

    func startUpdating() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            withAnimation(.linear) {
                self.maintainHR()
                
                // Debugging: Confirm that the timer block is being executed
                print("Timer fired")
                
                // Check if currentRate is set
                if let currentRate = self.currentRate {
                    print("Current Rate: \(currentRate.hr)")
                    // Check if the last heart rate is different
                    if currentRate.hr != self.heartRates.last?.hr {
                        print("새로운 심박수 추가: \(currentRate.hr)")
//                        DispatchQueue.main.async {
                            self.heartRates.append(HeartRate(hr: currentRate.hr, date: Date()))
//                            self.heartRates.append(HeartRate(hr: currentRate.hr, date: Date()))
//                            self.heartRates.append(HeartRate(hr: currentRate.hr, date: Date()))
                            
//                        }
                    } else {
                        print("동일한 심박수. 0을 추가합니다.")
//                        DispatchQueue.main.async {
                            self.heartRates.append(HeartRate(hr: 0, date: Date()))
//                        }
                    }
                    self.currentRate = self.heartRates.last
                } else {
                    print("currentRate is nil")
                }
            }
        }
    }

    func maintainHR() {
        // Ensure this function is not called excessively; consider using DispatchQueue.main.async
        DispatchQueue.main.async {
            while self.heartRates.count > 300 {
                self.heartRates.removeFirst() // Maintain list length
            }
        }
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
        }
    }

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
        maintainHR()
        print("받은 값:\(hr), \(date)")
        currentRate = HeartRate(hr: hr, date: date)
    }
}
