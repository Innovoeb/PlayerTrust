//
//  XRPWallet_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/24/21.
//

import SwiftUI
import Combine

struct XRPWallet: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        VStack (spacing: 20)
        {
            Spacer()
            Text("XRP Deposit Address")
                .font(.title)
            Spacer()
            Text("Deposit XRP into the address listed below. When PlayerTrust receives the tokens your balance will be updated.")
            Divider()
            Text(user.xrpWallet)
            Spacer()
        }
        .padding(.horizontal)
        .onAppear()
        {
            user.getCurrentUserDocument()
        }
    }
}

struct XRPWallet_V_Previews: PreviewProvider {
    static var previews: some View {
        XRPWallet()
    }
}
