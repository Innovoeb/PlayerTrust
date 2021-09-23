//
//  PlayerAuthDetail_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct PlayerAuthDetail: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        VStack (alignment: .center, spacing: 10)
        {
            Text(user.name)
            Text(user.DOB)
            Text(user.SSN)
            Divider()
            Text(user.street1)
            Text(user.street2)
            Text(user.city)
            Text(user.state)
            Text(user.postalCode)
        }
        .onAppear()
        {
            user.getContact()
        }
        .padding(.top)
        Spacer()
        AccountHomeButton()
    }
}

struct PlayerAuthDetail_V_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAuthDetail()
    }
}
