//
//  PlayerAuthForm_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/18/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PlayerAuthForm: View
{
    @EnvironmentObject var user: User
    
    @State private var name: String = ""
    @State private var DOB: String = ""
    @State private var SSN: String = ""
    
    @State private var street1: String = ""
    @State private var street2: String = ""
    @State private var postalCode: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    
    
    @State private var errorMessage: String?
    
    let window = UIApplication.shared.windows.first
    
    
    var body: some View
    {
        Text("PlayerAuth™")
            .font(.largeTitle)
        ExDivider()
        VStack
        {
            Form
            {
                // PII
                Section
                {
                    TextField("Name", text: $name)
                    TextField("DOB YYYY-MM-DD", text: $DOB)
                    SecureField("SSN", text: $SSN)
                }
                
                // Address
                Section
                {
                    TextField("Address", text: $street1)
                    TextField("Apt/Suite", text: $street2)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Postal Code", text: $postalCode)
                }
                
                HStack
                {
                    Spacer()
                    Button("Submit")
                    {
                        createAccountWithContact()
                        
                        // after form submit send to image upload view
                        window?.rootViewController = UIHostingController(rootView: UploadDocuments().environmentObject(User()))
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
                LogoutButton()
            }
        }
    }
    
    func createAccountWithContact()
    {
        let parameters = "{\n    \"data\": {\n        \"type\": \"account\",\n        \"attributes\": {\n            \"account-type\": \"custodial\",\n            \"name\": \"\(name)'s PlayerTrust Wallet\",\n            \"authorized-signature\": \"PlaterTrust\",\n            \"owner\": {\n                \"contact-type\": \"natural_person\",\n                \"name\": \"\(name)\",\n                \"email\": \"Innovoeb@gmail.com\",\n                \"date-of-birth\": \"\(DOB)\",\n                \"tax-id-number\": \"\(SSN)\",\n                \"tax-country\": \"US\",\n                \"primary-phone-number\": {\n                    \"country\": \"US\",\n                    \"number\": \"7027779311\",\n                    \"sms\": true\n                },\n                \"primary-address\": {\n                    \"street-1\": \"\(street1)\",\n                    \"street-2\": \"\(street2)\",\n                    \"postal-code\": \"\(postalCode)\",\n                    \"city\": \"\(city)\",\n                    \"region\": \"\(state)\",\n                    \"country\": \"US\"\n                }\n            },\n            \"webhook-config\": {\n                \"contact-email\": \"Innovoeb@gmail.com\",\n                \"url\": \"https://webhook.site/ed2c904e-9f94-4775-983e-527c1bf9f253\",\n                \"enabled\": true\n            }\n        }\n    }\n}"
        
        let postData = parameters.data(using: .utf8)
        
        
        
        print("Making api call...")
        
        guard let url = URL(string: "https://sandbox.primetrust.com/v2/accounts?include=contacts")
        else
        {
            return
        }
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request)
        {  (data, response, error) in
            
            guard let data = data, error == nil else
            {
            print(String(describing: error))
            return
            }
            do
            {
                //print(String(data: data, encoding: .utf8)!)
                //print("Response: \(response!)")
                let respData = try JSONDecoder().decode(CreateAccountResponse.self, from: data)
                
                DispatchQueue.main.async
                {
                    user.accountStatus = respData.data.attributes.status // grab account status
                    user.accountID = respData.data.id // grab the account's ID
                    user.contactID = respData.data.relationships.contacts.data[0].id // grab the contact's ID
                    
                    // update user document in firestore with newly created account and contact ID from PT
                    let db = Firestore.firestore()
                    let users = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    users.updateData(["contactID": user.contactID, "accountID": user.accountID])
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
}

struct PlayerAuthForm_V_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAuthForm()
    }
}
