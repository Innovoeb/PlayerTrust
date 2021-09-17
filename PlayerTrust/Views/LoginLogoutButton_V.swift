//
//  Login:Logout_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/16/21.
//

import SwiftUI
import FirebaseAuth

struct LoginLogoutButton: View
{
    let window = UIApplication.shared.windows.first
    @EnvironmentObject var user: User
    
    
    var body: some View
    {
        HStack
        {
            if (user.userLoggedIn == true)
            {
                Button("Logout")
                {
                    // run method that logs user out of account
                    print("logging out of account...")
                    logout()
                    
                }
            }
            else
            {
                Button("Login")
                {
                    window?.rootViewController = UIHostingController(rootView: LoginSignupForm().environmentObject(User()))
                    window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    func logout()
    {
        
        
        DispatchQueue.main.async
        {
            try! Auth.auth().signOut()
            user.userLoggedIn = false
            window?.rootViewController = UIHostingController(rootView: RootView().environmentObject(User()))
            window?.makeKeyAndVisible()
            
//            // if sign in successful
//            if error == nil
//            {
//                print("Logging into account...")
//                window?.rootViewController = UIHostingController(rootView: AccountHome())
//                window?.makeKeyAndVisible()
//            }
//            else
//            {
//                // if there's an issue with logging in
//                errorMessage = error!.localizedDescription
//            }
        }
    }
}

struct Login_Logout_V_Previews: PreviewProvider {
    static var previews: some View {
        LoginLogoutButton()
    }
}
