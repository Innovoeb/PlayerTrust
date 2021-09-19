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
        VStack
        {
            Spacer()
            Text("Hello \(user.userUsername)")
            Spacer()
    
            VStack (spacing: 20)
            {
                Text("PlayerAuth™")
                    .onTapGesture
                    {
                        window?.rootViewController = UIHostingController(rootView: PlayerAuthForm().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                if (user.contactID != "")
                {
                    Text(user.accountStatus) 
                }
                Divider()
                VStack
                {
                    Image(systemName:"bag.circle.fill")
                    Text("PlayerTrust Wallet™")
                }
                .onTapGesture
                {
                    
                }
            }
            .onAppear()
            {
                user.getKYPStatus()
            }
            
            
            Spacer()
            LoginLogoutButton()
            Spacer()
        }
        .onAppear()
        {
            print("is a user logged in?: \(user.userLoggedIn)")
            user.getUser()
        }
    }
    
    func getContact()
    {
        
    }
    
}

//struct AccountHome_V_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountHome().environmentObject(User())
//    }
//}
