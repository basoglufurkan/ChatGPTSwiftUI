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
    @State private var showingSheet = false
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
                
//                HStack {
//                    Image(systemName: "checkmark.seal.fill")
//                        .foregroundColor(.cyan)
//                    Text(trial)
//                        .font(.system(size: 23))
//                        .fontWeight(.bold)
//                        .minimumScaleFactor(0.6)
//                }
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
            
            HStack {
                
                Button {
                    self.showingSheet = true
                    
                } label: {
                    
                    Text("Privacy")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding()
                    
                }
                .sheet(isPresented: $showingSheet) {
                            ScrollView {
                                Text("**Privacy Policy** \nYaren Basoglu built the Synthia - Friendly Chatbot app as a Free app. This SERVICE is provided by Yaren Basoglu at no cost and is intended for use as is. \nThis page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service. \nIf you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy. \nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Synthia - Friendly Chatbot unless otherwise defined in this Privacy Policy. \n**Information Collection and Use** \nFor a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way. \nThe app does use third-party services that may collect information used to identify you. \nLink to the privacy policy of third-party service providers used by the app \n*   [Google Analytics for Firebase](https://firebase.google.com/policies/analytics) \n*   [Firebase Crashlytics](https://firebase.google.com/support/privacy/) \n*   [RevenueCat](https://www.revenuecat.com/privacy) \n**Log Data** \nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics. \n**Cookies** \nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. \nThis Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service. \n**Service Providers** \nI may employ third-party companies and individuals due to the following reasons: \n*   To facilitate our Service; \n*   To provide the Service on our behalf; \n*   To perform Service-related services; or \n*   To assist us in analyzing how our Service is used. \nI want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose. \n**Security** \nI value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security. \n**Links to Other Sites** \nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services. \n**Children’s Privacy** \nThese Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions. \n**Changes to This Privacy Policy** \nI may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. \nThis policy is effective as of 2023-03-23 \n**Contact Us** \nIf you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at appxmobile.info@gmail.com..")
                                    .font(.caption)
                                    .padding()
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
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding()
                    
                }
                
                Button {
                    self.showingSheet = true
                    
                } label: {
                    
                    Text("Terms")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .padding()
                    
                }
                .sheet(isPresented: $showingSheet) {
                            ScrollView {
                                Text("**Terms & Conditions** \nBy downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Yaren Basoglu. \nYaren Basoglu is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for. \nThe Synthia - Friendly Chatbot app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Synthia - Friendly Chatbot app won’t work properly or at all. \nThe app does use third-party services that declare their Terms and Conditions. \nLink to Terms and Conditions of third-party service providers used by the app \n*   [Google Analytics for Firebase](https://firebase.google.com/terms/analytics) \n*   [Firebase Crashlytics](https://firebase.google.com/terms/crashlytics) \n*   [RevenueCat](https://www.revenuecat.com/terms) \nYou should be aware that there are certain things that Yaren Basoglu will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Yaren Basoglu cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left. \nIf you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app. \nAlong the same lines, Yaren Basoglu cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Yaren Basoglu cannot accept responsibility. \nWith respect to Yaren Basoglu’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Yaren Basoglu accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app. \nAt some point, we may wish to update the app. The app is currently available on iOS – the requirements for the system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Yaren Basoglu does not promise that it will always update the app so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device. \n**Changes to This Terms and Conditions** \nI may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page. \nThese terms and conditions are effective as of 2023-03-23 \n**Contact Us** \nIf you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at appxmobile.info@gmail.com.")
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
    
    func privacyText() -> NSAttributedString {
           let markdownString = "**Privacy Policy** \nYaren Basoglu built the Synthia - Friendly Chatbot app as a Free app. This SERVICE is provided by Yaren Basoglu at no cost and is intended for use as is. \nThis page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service. \nIf you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy. \nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Synthia - Friendly Chatbot unless otherwise defined in this Privacy Policy. \n**Information Collection and Use** \nFor a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way. \nThe app does use third-party services that may collect information used to identify you. \nLink to the privacy policy of third-party service providers used by the app \n*   [Google Analytics for Firebase](https://firebase.google.com/policies/analytics) \n*   [Firebase Crashlytics](https://firebase.google.com/support/privacy/) \n*   [RevenueCat](https://www.revenuecat.com/privacy) \n**Log Data** \nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics. \n**Cookies** \nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. \nThis Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service. \n**Service Providers** \nI may employ third-party companies and individuals due to the following reasons: \n*   To facilitate our Service; \n*   To provide the Service on our behalf; \n*   To perform Service-related services; or \n*   To assist us in analyzing how our Service is used. \nI want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose. \n**Security** \nI value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security. \n**Links to Other Sites** \nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services. \n**Children’s Privacy** \nThese Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions. \n**Changes to This Privacy Policy** \nI may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. \nThis policy is effective as of 2023-03-23 \n**Contact Us** \nIf you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at appxmobile.info@gmail.com.."
           let attributedString = NSMutableAttributedString(string: markdownString)
           let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17)]
           let italicAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.italicSystemFont(ofSize: 17)]
           let codeAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Menlo", size: 17)!, .foregroundColor: UIColor.blue]
           
           let regexBold = try! NSRegularExpression(pattern: "(\\*\\*|__)\\S.*?\\S\\1")
           let matchesBold = regexBold.matches(in: markdownString, range: NSRange(markdownString.startIndex..., in: markdownString))
           for match in matchesBold.reversed() {
               attributedString.addAttributes(boldAttributes, range: match.range)
           }
           
           let regexItalic = try! NSRegularExpression(pattern: "(\\*|_)\\S.*?\\S\\1")
           let matchesItalic = regexItalic.matches(in: markdownString, range: NSRange(markdownString.startIndex..., in: markdownString))
           for match in matchesItalic.reversed() {
               attributedString.addAttributes(italicAttributes, range: match.range)
           }
           
           let regexCode = try! NSRegularExpression(pattern: "(``|`)(.|\\n)*?\\1")
           let matchesCode = regexCode.matches(in: markdownString, range: NSRange(markdownString.startIndex..., in: markdownString))
           for match in matchesCode.reversed() {
               attributedString.addAttributes(codeAttributes, range: match.range)
           }
           
           return attributedString
       }
}

struct Paywall_Previews: PreviewProvider {
    static var previews: some View {
        Paywall(isPaywallPresented: .constant(false))
    }
}
