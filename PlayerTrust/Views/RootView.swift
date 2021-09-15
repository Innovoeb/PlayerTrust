//
//  RootView.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/14/21.
//

import SwiftUI

struct RootView: View
{
    var body: some View
    {
        
        TabView
        {
            Home()
                .tabItem
                {
                    VStack
                    {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
            
            Login_Signup_V()
                .tabItem
                {
                    VStack
                    {
                        Image(systemName: "square.and.pencil")
                        Text("Sign In")
                    }
                }

        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
