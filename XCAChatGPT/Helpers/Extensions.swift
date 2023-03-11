//
//  Extensions.swift
//  XCAChatGPT
//
//  Created by Furkan BAŞOĞLU on 7.03.2023.
//

import Foundation
import RevenueCat
import StoreKit
import SwiftUI

/* Some methods to make displaying subscription terms easier */

extension Package {
    func terms(for package: Package) -> String {
        if let intro = package.storeProduct.introductoryDiscount {
            if intro.price == 0 {
                return "\(intro.subscriptionPeriod.periodTitle) free trial"
            } else {
                return "\(package.localizedIntroductoryPriceString!) for \(intro.subscriptionPeriod.periodTitle)"
            }
        } else {
            return "Unlocks Premium"
        }
    }
}

extension SubscriptionPeriod {
   
    var durationTitle: String {
        switch self.unit {
        case .day: return "day"
        case .week: return NSLocalizedString("week", comment: "")
        case .month: return NSLocalizedString("month", comment: "")
        case .year: return NSLocalizedString("year", comment: "")
        @unknown default: return "Unknown"
        }
    }
    
    var periodTitle: String {
        let periodString = "\(self.value) \(self.durationTitle)"
        let pluralized = self.value > 1 ?  periodString + "s" : periodString
        return pluralized
    }
}

