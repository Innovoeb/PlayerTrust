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
        Text("PlayerAuth™")
            .font(.largeTitle)
        ExDivider()
        VStack (alignment: .center, spacing: 10)
        {
            //Spacer()
            Text(user.name)
            Text(user.DOB)
            Text(user.SSN)
            Divider()
            Text(user.street1)
            Text(user.street2)
            Text("\(user.city), \(user.state)")
            Text(user.postalCode)
        }
        .onAppear()
        {
            user.getContact()
        }
        .padding(.top)
        
        
        
        if (user.uploadedDocuments == false)
        {
            Spacer()
            Button("Upload Driver's License/Identification")
            {
                let window = UIApplication.shared.windows.first
                window?.rootViewController = UIHostingController(rootView: UploadDocuments().environmentObject(User()))
                window?.makeKeyAndVisible()
            }
        }
        
        Spacer()
        HStack (spacing: 65)
        {
            AccountHomeButton()
            LogoutButton()
        }
    }
}

struct PlayerAuthDetail_V_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAuthDetail()
    }
}
