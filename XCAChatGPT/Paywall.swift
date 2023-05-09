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
    let info: LocalizedStringKey = "info"
    let privacy: LocalizedStringKey = "privacy"
    let term: LocalizedStringKey = "term"
    @State private var showingSheet = false
    @State private var showingSheet2 = false
    var body: some View {
        
        
        VStack (alignment: .center) {
            
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
            

            Image(uiImage: UIImage(named: "openai")!)
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
                        .minimumScaleFactor(0.5)
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
                        .minimumScaleFactor(0.5)
                }
            }
            
            Spacer()
            
            if currentOffering != nil {
                
                ForEach(currentOffering!.availablePackages) { pkg in
                    
                    Button {
                        // BUY
                        Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                            
                            if customerInfo?.entitlements.all["gpt"]?.isActive == true {
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
            
            HStack {
                
                Button {
//                    if let url = URL(string: "https://sites.google.com/view/chattygpt-privacy/ana-sayfa") {
//                        UIApplication.shared.open(url)
//                    }
                    self.showingSheet = true

                }label: {
                    Text("Privacy")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding()
                }
                .sheet(isPresented: $showingSheet) {
                    ScrollView {
                        Text(privacy)
                            .font(.caption)
                            .padding()
                    }
                    
                }
            
                Button {
                    // Restore Purchases
                    Purchases.shared.restorePurchases { (customerInfo, error) in
                        //... check customerInfo to see if entitlement is now active
                        
                        userViewModel.isSubscriptionActive = customerInfo?.entitlements.all["gpt"]?.isActive == true
                    }
                } label: {
                    Text("Restore")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding()
                }
                
                Button {
                    self.showingSheet2 = true

//                    if let url = URL(string: "https://sites.google.com/view/chattygpt-term-of-service/ana-sayfa") {
//                        UIApplication.shared.open(url)
//                    }
                }label: {
                    Text("Terms")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding()
                }
                .sheet(isPresented: $showingSheet2) {
                    ScrollView {
                        Text(term)
                            .font(.caption)
                            .padding()
                    }
                    
                }

                
                
                

            }
            
            VStack (alignment: .center){
                Text(info)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(.gray)
                
            }
            .frame(height: 100)
               
            
            
        }
        .padding(30)
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
