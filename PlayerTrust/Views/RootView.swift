//
//  RootView.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/14/21.
//

import SwiftUI
import FirebaseAuth

struct RootView: View
{
    @EnvironmentObject var user: User
    
    init()
    {
        
    }
    
    var body: some View
    {
        if (user.userLoggedIn == false)
        {
            TabView
            {
                Home().environmentObject(User()).environmentObject(PrimeTrust())
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                
                LoginSignupForm().environmentObject(User()).environmentObject(PrimeTrust())
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "square.and.pencil")
                            Text("Login")
                        }
                    }

            }
            .onAppear()
            {
                print("is a user logged in?: \(user.userLoggedIn)")
                user.userLoggedIn = Auth.auth().currentUser == nil ? false : true // check if a user is logged in
            }
            .environmentObject(User())
        }
        else
        {
            AccountHome().environmentObject(PrimeTrust())
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
