//
//  Login:Logout_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/16/21.
//

import SwiftUI
import FirebaseAuth

struct LogoutButton: View
{
    let window = UIApplication.shared.windows.first
    @EnvironmentObject var user: User
    
    
    var body: some View
    {
        VStack
        {
            Image(systemName: "square.and.pencil").renderingMode(.template)
            Text("Logout")
        }
        .onTapGesture
        {
            logout()
        }
        
        
        
//        HStack
//        {
//            if (user.userLoggedIn == true)
//            {
//                Button("Logout")
//                {
//                    // run method that logs user out of account
//                    print("logging out of account...")
//                    logout()
//                }
//                .foregroundColor(Color.black)
//            }
//        }
    }
    
    func logout()
    {
        DispatchQueue.main.async
        {
            try! Auth.auth().signOut()
            user.userLoggedIn = false
            window?.rootViewController = UIHostingController(rootView: RootView().environmentObject(User()))
            window?.makeKeyAndVisible()
        }
    }
}

struct Login_Logout_V_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
    }
}
