//
//  Paywall.swift
//  XCAChatGPT
//
//  Created by Furkan BAŞOĞLU on 7.03.2023.
//

import SwiftUI
import RevenueCat

struct Paywall: View {
    
    @Binding var isPaywallPresented: Bool

    @State var currentOffering: Offering?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    let premium: LocalizedStringKey = "premium"
    let trial: LocalizedStringKey = "trial"
    let text1: LocalizedStringKey = "text1"
    let text2: LocalizedStringKey = "text2"
    let text3: LocalizedStringKey = "text3"
    let unlock: LocalizedStringKey = "unlock"
    var body: some View {
        
        
        VStack (alignment: .center
                , spacing: 20) {
            
//            HStack {
//                            Spacer()
//                            Button(action: {
//                                presentationMode.wrappedValue.dismiss()
//                            }, label: {
//                                Image(systemName: "xmark")
//                                    .foregroundColor(.gray)
//                                    .font(.system(size: 20, weight: .medium))
//                            })
//                        }
            
            Text(premium)
                .bold()
                .font(Font.title)
            

            
            Image(uiImage: UIImage(named: "profile")!)
                .resizable()
                .scaledToFit()
                
                .frame(width: 200, height: 200, alignment: .center)
                
            
            VStack (alignment: .leading, spacing: 10) {
                Text(unlock)
                    .foregroundColor(.cyan)
                    .font(.system(size: 20))
                    .font(Font.subheadline)
                    .bold()
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.cyan)
                    Text(text1)
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.7)
                }
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.cyan)
                    Text(text2)
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                }
                
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.cyan)
                    Text(text3)
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                }
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.cyan)
                    Text(trial)
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                }
            }
            
            
            
            Spacer()
            
            if currentOffering != nil {
                
                ForEach(currentOffering!.availablePackages) { pkg in
                    
                    Button {
                        // BUY
                        Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                            
                            if customerInfo?.entitlements.all["pro"]?.isActive == true {
                                // Unlock that great "pro" content
                                
                                userViewModel.isSubscriptionActive = true
                                isPaywallPresented = false
                            }
                        }
                        
                    } label: {
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 45)
                                .foregroundColor(.cyan)
                                .cornerRadius(10)
                            
                            
                            Text("\(pkg.storeProduct.subscriptionPeriod!.periodTitle) \(pkg.storeProduct.localizedPriceString)")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                
            }
            
            
            
            
            Button {
                // Restore Purchases
                Purchases.shared.restorePurchases { (customerInfo, error) in
                    //... check customerInfo to see if entitlement is now active
                    
                    userViewModel.isSubscriptionActive = customerInfo?.entitlements.all["pro"]?.isActive == true
                }
                
            } label: {
                
                Text("Restore")
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
            }
            
        }
        .padding(50)
        .onAppear {
            
            Purchases.shared.getOfferings { offerings, error in
                
                if let offer = offerings?.current, error == nil {
                    
                    currentOffering = offer
                }
            }
        }
    }
}

struct Paywall_Previews: PreviewProvider {
    static var previews: some View {
        Paywall(isPaywallPresented: .constant(false))
    }
}
