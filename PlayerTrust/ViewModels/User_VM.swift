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
                print(docSnapshot.data() ?? "") // should return username
                
                let data = docSnapshot.data()
                self.userUsername = data!["username"] as! String
                self.userID = data!["userID"] as! String
                self.contactID = data!["contactID"] as! String
                
                if (self.contactID == "")
                {
                    print("No ContactID Found")
                }
                else
                {
                    print("User Has a ContactID")
                }
            }
            else
            {
                print("Error: No Data Returned")
            }
        }
    }
    
    
    // check account based on contact ID and grab the account's KYC status
    func getKYPStatus()
    {
        // grab user document from firestore
        
        // if document has empty value for contactID, then change account status prop value
        
        // if document does have a contactID, make a call to the PT API and grab the account status
        
    }
}
