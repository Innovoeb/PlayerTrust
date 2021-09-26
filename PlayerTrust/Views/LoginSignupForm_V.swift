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
    @EnvironmentObject var user: User
    
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    @State private var signUpUsername: String = ""
    @State private var signUpPassword: String = ""
    @State private var signUpEmail: String = ""
    
    @State private var errorMessage: String?
    
    // grab the current window/view of the application
    let window = UIApplication.shared.windows.first
    
    var body: some View
    {
        VStack
        {
            Form
            {
                // login to an existing account
                Section
                {
                    TextField("Email", text: $loginEmail)
                    SecureField("Password", text: $loginPassword)
                }
                if (errorMessage != nil)
                {
                    Section
                        {
                            Text(errorMessage!)
                        }
                }
                HStack
                {
                    Spacer()
                    Button("Login")
                    {
                        login()
                    }
                    Spacer()
                }
                
                // create an account
                Section
                {
                    TextField("Email", text: $signUpEmail)
                    SecureField("Password", text: $signUpPassword)
                    TextField("Username", text: $signUpUsername)
                    
                }
                if (errorMessage != nil)
                {
                    Section
                    {
                        Text(errorMessage!)
                    }
                }
                HStack
                {
                    Spacer()
                    Button("Create Account")
                    {
                       createAccount()
                    }
                    Spacer()
                }
            }
        }
    }
    
    
    // MARK: Possibly Move these 3 functions into a viewmodel?
    func createAccount()
    {
        Auth.auth().createUser(withEmail: signUpEmail, password: signUpPassword)
        { result, error in
            
            DispatchQueue.main.async
            {
                // no errors, proceed
                if (error == nil)
                {
                    saveUser()
                    user.userLoggedIn = true
                    
                    // send to AccountHome View
                    window?.rootViewController = UIHostingController(rootView: AccountHome().environmentObject(User()))
                    window?.makeKeyAndVisible()
                }
                
                else
                {
                    errorMessage = error?.localizedDescription
                }
            }
        }
    }
    
    func saveUser()
    {
        if let currentUser = Auth.auth().currentUser
        {
            let cleansedUsername = signUpUsername.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let db = Firestore.firestore()
            let path = db.collection("users").document(currentUser.uid)
            
            path.setData(["username" : cleansedUsername, "userID": currentUser.uid, "email" : currentUser.email ?? "", "contactID" : "", "accountID" : "", "uploaded-documents" : false, "walletsCreated" : false, "bitcoinATM" : "", "bitcoinWallet" : "", "etherATM" : "", "etherWallet" : "", "xrpATM" : "", "xrpWallet" : ""])
            {
                error in
                
                if error == nil
                {
                    print("Success! New User Was Added to Firestore")
                }
                else
                {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    func login()
    {
        Auth.auth().signIn(withEmail: loginEmail, password: loginPassword) { result, error in
            
            DispatchQueue.main.async
            {
                // if sign in successful
                if error == nil
                {
                    print("Logging into account...")
                    user.userLoggedIn = true
                    window?.rootViewController = UIHostingController(rootView: AccountHome().environmentObject(User()))
                    window?.makeKeyAndVisible()
                }
                else
                {
                    // if there's an issue with logging in
                    errorMessage = error!.localizedDescription
                }
            }
        }
    }
}

struct Login_Signup_V_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupForm()
    }
}
