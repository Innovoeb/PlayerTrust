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
        Logo()
        VStack (alignment: .center, spacing: 10)
        {
            Text("PlayerAuth™")
                .font(.largeTitle)
            Spacer()
            if (user.playerauthDetailIsLoading == true)
            {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
            }
            else
            {
                VStack (spacing: 8.5)
                {
                    Text(user.name)
                    Text(user.email)
                    Text(user.DOB)
                    Text(user.SSN.masked)
                    Divider()
                    Text(user.street1)
                    Text(user.street2)
                    Text("\(user.city), \(user.state)")
                    Text(user.postalCode)
                }
               
                Spacer()
                if (user.uploadedDocuments == false)
                {
                    VStack
                    {
                        Image(systemName:"camera.on.rectangle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Upload Driver's License/Identification")
                    }
                    .onTapGesture
                    {
                        let window = UIApplication.shared.windows.first
                        window?.rootViewController = UIHostingController(rootView: UploadDocuments().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear()
        {
            user.getContact()
            user.playerauthDetailIsLoading = true
        }
        .padding(.top)
        
        Spacer()
        HStack (spacing: 65)
        {
            AccountHomeButton()
            LogoutButton()
        }
    }
    
}

// extention that when added to the SSN will only show last 4 digits
extension StringProtocol
{
    var masked: String
    {
        return String(repeating: "*", count: Swift.max(0, count-4)) + suffix(4)
    }
}

struct PlayerAuthDetail_V_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAuthDetail()
    }
}
