//
//  BitcoinWallet_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/24/21.
//

import SwiftUI

struct BitcoinWallet: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        VStack (spacing: 20)
        {
           Spacer()
            Text("Bitcoin Deposit Address")
                .font(.title)
            Spacer()
            Text("Deposit Bitcoin into the address listed below. When PlayerTrust receives the tokens your balance will be updated.")
            Divider()
            Text(user.bitcoinWallet)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct BitcoinWallet_V_Previews: PreviewProvider {
    static var previews: some View {
        BitcoinWallet()
    }
}
