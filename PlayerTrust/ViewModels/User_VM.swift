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
    
    init()
    {
        userLoggedIn = Auth.auth().currentUser == nil ? false : true // check if a user is logged in
        
    }
    
    // MARK: Get User Document From Firestore
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
                self.userUsername = data!["username"] as! String
                self.userID = data!["userID"] as! String
                self.contactID = data!["contactID"] as! String
                self.accountID = data!["accountID"] as! String
                print("Get User Document - accountID: \(self.accountID)")
                
                if (self.accountID != "")
                {
                    self.getKYPStatus()
                }
                else
                {
                    print("Did Not Grab AccountID")
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
                print(String(data: data, encoding: .utf8)!)
                print("response: \(response!)")
                print("GetKYC - accountID: \(self.accountID)")
                let respData = try JSONDecoder().decode(AccountModel.self, from: data)
                
                DispatchQueue.main.async
                {
                    self.accountStatus = respData.accountData.attributes.status
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
