//
//  HeartTacker.swift
//  HeartRateTracker
//
//  Created by Taewon Yoon on 9/2/24.
//

import SwiftUI
import HealthKit

@Observable
class HeartTracker: iOSConnectivity {
    
    private let healthStore = HKHealthStore()
    private let heartRateQuantity = HKUnit(from: "count/min")
    let fristDate = Date()
    var heartRate = 0
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [HKQuantityType(.heartRate)]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
        
    // 심박수 측정하기
    func startHeartRateQuery(_ quantityTypeIdentifier: HKQuantityTypeIdentifier = .heartRate) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in

            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            self.process(samples, type: quantityTypeIdentifier)
        }

        let query = HKAnchoredObjectQuery(type: HKQuantityType(quantityTypeIdentifier), predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
            var lastHeartRate = 0
        for sample in samples.filter({ $0.endDate > fristDate }) {
                if type == .heartRate {
                    lastHeartRate = Int(sample.quantity.doubleValue(for: heartRateQuantity))
                    sendHeartRate(heartRate: lastHeartRate, date: sample.endDate)
                    heartRate = lastHeartRate
                }
                
                print("측정되는 심박수: \(Int(lastHeartRate)), 측정된 시간: \(sample.startDate) ~ \(sample.endDate)")
            }
        }

}
