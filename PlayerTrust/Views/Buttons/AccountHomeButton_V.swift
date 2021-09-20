//
//  AccountHomeButton_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct AccountHomeButton: View
{
    let window = UIApplication.shared.windows.first
    
    var body: some View
    {
        VStack
        {
            Image(systemName: "house.fill")
            Text("Home")
        }
        .onTapGesture
        {
            window?.rootViewController = UIHostingController(rootView: AccountHome().environmentObject(User()))
            window?.makeKeyAndVisible()
        }
    }
}

struct AccountHomeButton_V_Previews: PreviewProvider {
    static var previews: some View {
        AccountHomeButton()
    }
}
