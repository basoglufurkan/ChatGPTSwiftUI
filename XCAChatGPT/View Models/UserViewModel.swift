//
//  UserViewModel.swift
//  XCAChatGPT
//
//  Created by Furkan BAŞOĞLU on 7.03.2023.
//

import Foundation
import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    
    init() {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            
                
            self.isSubscriptionActive = customerInfo?.entitlements.all["gpt"]?.isActive == true
            
        }
    }
    
}
