//
//  WithdrawForm_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/25/21.
//

import SwiftUI

struct WithdrawForm: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        Logo()
        let window = UIApplication.shared.windows.first
        
        VStack (spacing: 15)
        {
            VStack
            {
                Spacer()
                HStack (spacing: 5)
                {
                    Image(systemName: "exclamationmark.circle")
                    Menu ("Type of Coin to Withdraw")
                    {
                        Button("Bitcoin")
                        {
                            user.cointype = "bitcoin"
                        }
                        Button("Ether")
                        {
                            user.cointype = "ethereum"
                        }
                        Button("XRP")
                        {
                            user.cointype = "xrp"
                        }
                    }
                    .foregroundColor(Color.black)
                }
                
                
                Divider()
                Spacer()
            }
            
            if (user.cointype == "bitcoin")
            {
                Text("BTC")
                    .font(.title)
            }
            if (user.cointype == "ethereum")
            {
                Text("Ether")
                    .font(.title)
            }
            if (user.cointype == "xrp")
            {
                Text("XRP")
                    .font(.title)
            }
            
            Form
            {
                Section
                {
                    TextField("Amount", text: $user.amount)
                    TextField("Wallet Address", text: $user.outgoingWallet)
                }
                
                HStack
                {
                    Spacer()
                    Button("Submit")
                    {
                        user.coinWithdraw()
                        window?.rootViewController = UIHostingController(rootView: PlayerTrustWallet().environmentObject(User()))
                            window?.makeKeyAndVisible()
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
            
            
            Spacer()
            // MARK: TODO: Make an Alert Here!
            HStack (spacing: 65)
            {
                AccountHomeButton()
                PlayerTrustWalletButton()
                LogoutButton()
            }
        }
        .navigationTitle("Withdraw Coins")
    }
}

struct WithdrawForm_V_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawForm()
    }
}
