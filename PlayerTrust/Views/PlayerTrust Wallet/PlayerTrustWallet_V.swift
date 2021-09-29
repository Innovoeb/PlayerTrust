//
//  PlayerTrustWallet_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct PlayerTrustWallet: View
{
    @EnvironmentObject var user: User
    let window = UIApplication.shared.windows.first
    @State private var isLoading = false
    
    
    var body: some View
    {
        Logo()
        VStack (spacing: 30)
        {
            Spacer()
            VStack (spacing: 5)
            {
                if (user.assetBalanceIsLoading == true)
                {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(3)
                }
                else
                {
                    if (user.walletsCreated == true)
                    {
                        Text("\(user.bitcoinTotal) BTC")
                        Text("\(user.etherTotal) ETH")
                        Text("\(user.xrpTotal) XRP")
                    }
                    else
                    {
                        Text("Press the Deposit button to add tokens into your PlayerTrust wallet")
                    }
                }
            }
            .onAppear()
            {
                user.getCurrentUserDocument()
                user.assetBalanceIsLoading = true
                //startFakeNetworkCall()
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false)
                { timer in
                    user.getAssetBalance()
                }
            }
            .border(Color.black, width: 200.0)
            Divider()
            HStack (spacing: 65)
            {
                // static buttons; always showing whether the end user has made a deposit before or not
                
                HStack (spacing: 5)
                {
                    Image(systemName: "plus.circle")
                    Text("Deposit")
                }
                .onTapGesture
                {
                    if (user.walletsCreated == false)
                    {
                        // run a method that sends a POST to create asset transfer methods for all 3 tokens
                        user.createATM()
                        
                        // MARK: TODO, progress bar to allow for the creation of wallet addresses
                        
                        // navigate to Deposit Address tab view
                        window?.rootViewController = UIHostingController(rootView: DepositAddresses().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                    else
                    {
                        // just navigate to the deposit address tab view
                        window?.rootViewController = UIHostingController(rootView: DepositAddresses().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                }
                .foregroundColor(Color.black)
                HStack (spacing: 5)
                {
                    Image(systemName: "minus.circle")
                    Text("Withdraw")
                }
                .onTapGesture
                {
                    window?.rootViewController = UIHostingController(rootView: WithdrawForm().environmentObject(User()))
                    window?.makeKeyAndVisible()
                }
                .foregroundColor(Color.black)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear()
        {
            //user.getCurrentUserDocument()
        }
        
        Spacer()
        HStack (spacing: 65)
        {
            AccountHomeButton()
            LogoutButton()
        }
    }
    
    func startFakeNetworkCall()
    {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            isLoading = false
        }
    }
}
