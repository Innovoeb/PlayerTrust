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
    @State var selection: String? = nil
    let window = UIApplication.shared.windows.first

    
    var body: some View
    {
        
        
        NavigationView
        {
            // parent
            VStack (spacing: 20)
            {
                Logo()
                //Spacer()
                if (user.userUsername != "")
                {
                    Text("Hello \(user.userUsername)")
                        .font(.title)
                }
                Spacer()
                
                // see .onAppear of parent VStack below
                if (user.accountHomeIsLoading == true)
                {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(3)
                    Spacer()
                    
                }
                // when timer has changed accountHomeIsLoading to false; see initAccountHome() below
                else
                {
                    
                    
                    // PlayerAuth
                    VStack
                    {
                        
                        // setup to programatically navigate to appropriate view on tap of PlayerAuth™
                        NavigationLink(destination: PlayerAuthForm(), tag: "PlayerAuthForm", selection: $selection)
                        { EmptyView() }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        
                        NavigationLink(destination: PlayerAuthDetail(), tag: "PlayerAuthDetail", selection: $selection)
                        { EmptyView() }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        
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
                        playerAuthViewSelector()
                    }
                    Divider()
                    // PlayerTrust Wallet
                    VStack
                    {
                        NavigationLink(destination: PlayerTrustWallet(), tag: "PlayerTrustWallet", selection: $selection)
                        { EmptyView() }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        
                        
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
                            //window?.rootViewController = UIHostingController(rootView: PlayerTrustWallet().environmentObject(User()))
                            //window?.makeKeyAndVisible()
                            self.selection = "PlayerTrustWallet"
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
                user.accountHomeIsLoading = true // create loading(progress) spinner
                removeSpinner()
            }
        }
    }
    
    // buy time to load user document from cloud firestore (smoke n mirrors)
    func removeSpinner()
    {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { Timer in
            user.accountHomeIsLoading = false
        }
    }
    
    func playerAuthViewSelector()
    {
        if (user.contactID == "")
        {
            self.selection = "PlayerAuthForm"
        }
        else
        {
            self.selection = "PlayerAuthDetail"
            
        }
    }
}

