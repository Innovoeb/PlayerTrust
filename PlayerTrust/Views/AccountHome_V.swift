//
//  AccountHome_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/16/21.
//

import SwiftUI
import FirebaseAuth

struct AccountHome: View
{
    @EnvironmentObject var user: User
    
    let window = UIApplication.shared.windows.first

    
    var body: some View
    {
        Logo()
        VStack (spacing: 20)
        {
            Spacer()
            if (user.userUsername != "")
            {
                Text("Hello \(user.userUsername)")
                    .font(.title)
            }
            Spacer()
            
            if (user.accountHomeIsLoading == true)
            {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
                
            }
            else
            {
                // PlayerAuth
                VStack
                {
                    Text("PlayerAuth™")
                    if (user.accountStatus == "")
                    {
                        Text("(Begin Application)")
                        
                    }
                    else
                    {
                        if (user.accountIsOpen == false)
                        {
                            Text("(Pending)")
                                .foregroundColor(Color.red)
                            
                        }
                        else
                        {
                            Text("(Approved)")
                                .foregroundColor( Color(red: 57 / 255, green: 102 / 255, blue: 85 / 255) )
                            
                        }
                    }
                }
                .onTapGesture
                {
                    if (user.contactID == "")
                    {
                        window?.rootViewController = UIHostingController(rootView: PlayerAuthForm().environmentObject(User()))
                        window?.makeKeyAndVisible()
                        
                    }
                    else
                    {
                        window?.rootViewController = UIHostingController(rootView: PlayerAuthDetail().environmentObject(User()))
                        window?.makeKeyAndVisible()
                        
                    }
                }
                Divider()
                // PlayerTrust Wallet
                VStack
                {
                    if (user.contactID == "" || user.accountIsOpen == false)
                    {
                        Text("PlayerTrust Wallet™")
                            .foregroundColor(Color.gray)
                            
                    }
                    else
                    {
                        Text("PlayerTrust Wallet™")
                    }
                        
                    if (user.contactID == "" || user.accountIsOpen == false)
                    {
                        Image(systemName:"bag.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(0.2)
                    }
                    else
                    {
                        Image(systemName:"bag.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                .onTapGesture
                {
                    if (user.accountIsOpen == true)
                    {
                        window?.rootViewController = UIHostingController(rootView: PlayerTrustWallet().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                }
            }
                
            Spacer()
            // PlayerTrust Wallet VStack
            VStack (spacing: 20)
            {
                LogoutButton()
            }
        }
        .onAppear()
        {
            user.accountHomeIsLoading = true // initiate loading spinner
            initAccountHome()
        }
    }
    
    // stop loading spinner
    func initAccountHome()
    {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { Timer in
            user.accountHomeIsLoading = false
        }
    }
}

