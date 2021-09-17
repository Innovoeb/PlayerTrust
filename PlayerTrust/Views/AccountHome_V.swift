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
    
    
    init()
    {
        //user.getUser()
    }
    
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
                    .onTapGesture {
                        // send to PlayerAuth onboarding view
                    }
                Divider()
                VStack
                {
                    Image(systemName:"bag.circle.fill")
                    Text("PlayerTrust Wallet™")
                }
                .onTapGesture
                {
                    print("wallet image was tapped")
                }
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
    
}

struct AccountHome_V_Previews: PreviewProvider {
    static var previews: some View {
        AccountHome().environmentObject(User())
    }
}
