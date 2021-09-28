//
//  CreateAccount_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/28/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateAccount: View
{
    @EnvironmentObject var user: User
    @State private var signUpUsername: String = ""
    @State private var signUpPassword: String = ""
    @State private var signUpEmail: String = ""
    @State private var errorMessage: String?
    let window = UIApplication.shared.windows.first
    
    
    var body: some View
    {
        Form
        {
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
                .foregroundColor(Color.black)
                Spacer()
            }
        }
        .background(Color(red: 57 / 255, green: 102 / 255, blue: 85 / 255))
        .onAppear()
        {
            UITableView.appearance().backgroundColor = .clear
        }
    }
    
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
}

struct CreateAccount_V_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}
