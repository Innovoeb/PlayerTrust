//
//  AccountHomeButton_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct AccountHomeButton: View
{
    var body: some View
    {
        NavigationLink(destination: AccountHome())
        {
            VStack
            {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .accentColor(.black)
        }
    }
}

struct AccountHomeButton_V_Previews: PreviewProvider {
    static var previews: some View {
        AccountHomeButton()
    }
}
