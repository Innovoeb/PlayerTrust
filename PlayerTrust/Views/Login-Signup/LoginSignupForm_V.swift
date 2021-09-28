//
//  Login:Signup_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/14/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginSignupForm: View
{
    @State var isLoginShowing = false
    @State var isSignInShowing = false
    

    
    
    
    
    
//    @EnvironmentObject var user: User
//    @State private var loginEmail: String = ""
//    @State private var loginPassword: String = ""
//    @State private var signUpUsername: String = ""
//    @State private var signUpPassword: String = ""
//    @State private var signUpEmail: String = ""
//    @State private var errorMessage: String?
    
    // grab the current window/view of the application
    let window = UIApplication.shared.windows.first
    
    var body: some View
    {
        VStack (spacing: 50)
        {
            Text("Login")
                .onTapGesture {
                    self.isLoginShowing = true
                }
                .sheet(isPresented: $isLoginShowing)
                {
                    Login()
                }
            Divider()
            Text("Create Account")
                .onTapGesture {
                    self.isSignInShowing = true
                }
                .sheet(isPresented: $isSignInShowing)
                {
                    CreateAccount()
                }
        }
        .frame(height: 300.0)
    }
    
    
    
    
    
}

struct Login_Signup_V_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupForm()
    }
}
