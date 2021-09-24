//
//  User_VM.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/16/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class User: ObservableObject
{
    @Published var userID = ""
    @Published var userUsername = ""
    @Published var userLoggedIn:Bool
    @Published var accountStatus = ""
    @Published var contactID = ""
    @Published var accountID = ""
    @Published var accountIsOpen = false
    
    // PlayerAuth Detail View
    @Published var name = ""
    @Published var DOB = ""
    @Published var SSN = ""
    
    @Published var city = ""
    @Published var state = ""
    @Published var postalCode = ""
    @Published var street1 = ""
    @Published var street2 = ""
    
    init()
    {
        userLoggedIn = Auth.auth().currentUser == nil ? false : true // check if a user is logged in
    }
    
    // MARK: Get Firestore Document Related to Current User
    func getCurrentUserDocument()
    {
        let db = Firestore.firestore()
        let users = db.collection("users")
        let userData = users.document(Auth.auth().currentUser?.uid ?? "")

        // get the user's data from firestore
        userData.getDocument
        {
            docSnapshot, error in

            if let error = error
            {
                // handle error
                print(error.localizedDescription)
            }
            else if let docSnapshot = docSnapshot
            {
                //print(docSnapshot.data() ?? "")
                
                let data = docSnapshot.data()
                DispatchQueue.main.async
                {
                    self.userUsername = data!["username"] as! String
                    self.userID = data!["userID"] as! String
                    if (data!["accountID"] != nil)
                    {
                        self.contactID = data!["contactID"] as! String
                        self.accountID = data!["accountID"] as! String
                        
                        if (self.accountID != "")
                        {
                            self.getKYPStatus()
                        }
                        else
                        {
                            print("Did Not Grab AccountID")
                        }
                    }
                }
            }
            else
            {
                print("Error: No Data Returned")
            }
        }
    }
    
    // MARK: Grab the Associated PT Account's Status
    func getKYPStatus()
    {
        // use the accountID to make a GET to PT API and return the associated account's status
        var request = URLRequest(url: URL(string: "https://sandbox.primetrust.com/v2/accounts/\(self.accountID)")!)
            
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
            
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
                //print("GetKYC - accountID: \(self.accountID)")
                let respData = try JSONDecoder().decode(AccountModel.self, from: data)
                
                DispatchQueue.main.async
                {
                    self.accountStatus = respData.accountData.attributes.status
                    
                    if (self.accountStatus == "opened")
                    {
                        self.accountIsOpen = true
                    }
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: Grab the Associated PT Contact's Info
    func getContact()
    {
        
        // grab the contactID from firebase first to pass into URL
        let db = Firestore.firestore()
        let users = db.collection("users")
        let document = users.document(Auth.auth().currentUser?.uid ?? "")
        document.getDocument { docSnapshot, error in
            
            if let error = error
            {
                print(error.localizedDescription)
            }
            // perform PT API call after grabbing contactID from firestore
            else if let docSnapshot = docSnapshot
            {
                let data = docSnapshot.data()
                
                self.contactID = data!["contactID"] as! String
                
                var request = URLRequest(url: URL(string: "https://sandbox.primetrust.com/v2/contacts/\(self.contactID)?include=addresses")!)
                
                request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request)
                {  (data, response, error) in
                    
                    guard let data = data, error == nil else
                    {
                    print(String(describing: error))
                    return
                    }
                    do
                    {
                        //print("Response: \(response!)")
                        let respData = try JSONDecoder().decode(ContactModel.self, from: data)
                        
                        DispatchQueue.main.async
                        {
                            self.name = respData.data.attributes.name
                            self.DOB = respData.data.attributes.DOB
                            self.SSN = respData.data.attributes.SSN
                            
                            self.city = respData.included[0].attributes.city
                            self.state = respData.included[0].attributes.region
                            self.postalCode = respData.included[0].attributes.postalCode
                            self.street1 = respData.included[0].attributes.street1
                            self.street2 = respData.included[0].attributes.street2
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
    }
    
    func openAccount()
    {
        var request = URLRequest(url: URL(string: "https://sandbox.primetrust.com/v2/accounts/\(self.accountID)/sandbox/open")!,timeoutInterval: Double.infinity)
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
        }
        task.resume()
    }
}
