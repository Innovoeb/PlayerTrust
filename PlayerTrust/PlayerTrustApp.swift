//
//  PlayerTrustApp.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/14/21.
//

import SwiftUI
import Firebase

@main
struct PlayerTrustApp: App
{
    
    init()
    {
        FirebaseApp.configure()
    }
    
    var body: some Scene
    {
        WindowGroup {
            RootView()
        }
    }
}
