//
//  RootView.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/14/21.
//

import SwiftUI
import FirebaseAuth

// super/parent view
struct RootView: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        if (user.userLoggedIn == false)
        {
            Logo()
            TabView
            {
                Home()
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "house.fill").renderingMode(.template)
                            Text("Home")
                        }
                    }
                
                LoginSignupForm().environmentObject(User())
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "square.and.pencil").renderingMode(.template)
                            Text("Login")
                        }
                    }

            }
            .accentColor(.black)
            .onAppear()
            {
                print("is a user logged in?: \(user.userLoggedIn)")
            }
        }
        else
        {
            AccountHome()
        }
    }
}

