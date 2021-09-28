//
//  Login_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/28/21.
//

import SwiftUI
import FirebaseAuth

struct Login: View
{
    @EnvironmentObject var user: User
    let window = UIApplication.shared.windows.first
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    @State private var errorMessage: String?
    
    
    
    var body: some View
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

struct Login_V_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
