//
//  EtherWallet_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/24/21.
//

import SwiftUI

struct EtherWallet: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        VStack (spacing: 20)
        {
            Spacer()
            Text("Ether Deposit Address")
                .font(.title)
            Spacer()
            Text("Deposit Ether into the address listed below. When PlayerTrust receives the tokens your balance will be updated.")
            Divider()
            Text(user.etherWallet)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EtherWallet_V_Previews: PreviewProvider {
    static var previews: some View {
        EtherWallet()
    }
}
