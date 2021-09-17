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
    //@Published var usermodel = [UserModel]()
    
    @Published var userID = ""
    @Published var userUsername = ""
    @Published var userLoggedIn:Bool
    
    init()
    {
        userLoggedIn = Auth.auth().currentUser == nil ? false : true // check if a user is logged in
    }
    
    // send username and email to firebase
    
    
    
    func getUser()
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

                //try! docSnapshot.data(as: UserModel.self)
            }
            else
            {
                print("Error: No Data Returned")
            }
        }
    }
}
