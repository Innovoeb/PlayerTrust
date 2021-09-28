//
//  AccountHome_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/16/21.
//

import SwiftUI
import FirebaseAuth

struct AccountHome: View
{
    @EnvironmentObject var user: User
    
    let window = UIApplication.shared.windows.first
    
    
    var body: some View
    {
        Logo()
        VStack
        {
            Spacer()
            Text("Hello \(user.userUsername)")
                .font(.title)
            Spacer()
    
            VStack (spacing: 20)
            {
                VStack (spacing: 5)
                {
                    Text("PlayerAuth™")
                        .onTapGesture
                        {
                            if (user.contactID == "")
                            {
                                window?.rootViewController = UIHostingController(rootView: PlayerAuthForm().environmentObject(User()))
                                window?.makeKeyAndVisible()
                            }
                            else
                            {
                                window?.rootViewController = UIHostingController(rootView: PlayerAuthDetail().environmentObject(User()))
                                window?.makeKeyAndVisible()
                            }
                        }
                    if (user.accountStatus == "")
                    {
                        Text("(Begin)")
                    }
                    else
                    {
                        Text("(\(user.accountStatus))")
                    }
                }
                Divider()
                VStack
                {
                    Image(systemName:"bag.circle.fill")
                    Text("PlayerTrust Wallet™")
                }
                .onTapGesture
                {
                    window?.rootViewController = UIHostingController(rootView: PlayerTrustWallet().environmentObject(User()))
                    window?.makeKeyAndVisible()
                }
            }
            
            Spacer()
            VStack (spacing: 20)
            {
                LogoutButton()
            }
        }
        .onAppear()
        {
            user.getCurrentUserDocument()
        }
    }
}

//struct AccountHome_V_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountHome().environmentObject(User())
//    }
//}
