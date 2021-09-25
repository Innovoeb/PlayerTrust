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
    @Published var uploadedDocuments = false
    @Published var walletsCreated = false
    //@Published var bitcoinATM = ""
    @Published var bitcoinWallet = ""
    //@Published var etherATM = ""
    @Published var etherWallet = ""
    //@Published var xrpATM = ""
    @Published var xrpWallet = ""
    
    // PlayerAuth Detail View
    @Published var name = ""
    @Published var DOB = ""
    @Published var SSN = ""
    @Published var city = ""
    @Published var state = ""
    @Published var postalCode = ""
    @Published var street1 = ""
    @Published var street2 = ""
    
    // PT Assets
    @Published var bitcoinID = "798debbc-ec84-43ea-8096-13e2ebcf4749"
    @Published var etherID = "e63b0367-c47b-49be-987a-f14036b230cd"
    @Published var xrpID = "a1703b84-bbba-435d-a1d2-f8f73e9d01b6"
    
    init()
    {
        userLoggedIn = Auth.auth().currentUser == nil ? false : true // check if a user is logged in
        if (userLoggedIn == true)
        {
            getCurrentUserDocument()
        }
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
                    self.uploadedDocuments = data!["uploaded-documents"] as! Bool
                    self.walletsCreated = data!["walletsCreated"] as! Bool
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
                    
                    // grab wallet IDs
                    if (data!["bitcoinWallet"] != nil)
                    {
                        self.bitcoinWallet = data!["bitcoinWallet"] as! String
                    }
                    if (data!["etherWallet"] != nil)
                    {
                        self.etherWallet = data!["etherWallet"] as! String
                    }
                    if (data!["xrpWallet"] != nil)
                    {
                        self.xrpWallet = data!["xrpWallet"] as! String
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
    
    // MARK: Sandbox API Endpoint Call To Open PT Account
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
    
    // MARK: Change Bool in User's Firestore Document to True After an Image is Uploaded
    func imageWasUploaded()
    {
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil
        {
            let users = db.collection("users").document(Auth.auth().currentUser!.uid)
            users.updateData(["uploaded-documents" : true])
        }
    }
    
    // Create ATMs Associated with User
    func createATM()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)asset-transfer-methods")!,timeoutInterval: Double.infinity)
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let db = Firestore.firestore()
        
        
        // Bitcoin
        let bitcoinParams = """
        {
            "data" : {
                "type" : "asset-transfer-methods",
                "attributes" : {
                    "asset-id" : "\(self.bitcoinID)",
                    "asset-transfer-type" : "bitcoin",
                    "contact-id" : "\(self.contactID)",
                    "account-id" :"\(self.accountID)",
                    "transfer-direction" : "incoming",
                    "single-use" : false
                }
            }
        }
        """
        
        let bitcoinPostData = bitcoinParams.data(using: .utf8)
        request.httpBody = bitcoinPostData
        
        var task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let respData = try JSONDecoder().decode(ATMResponse.self, from: data)
                DispatchQueue.main.async
                {
                    self.bitcoinWallet = respData.data.attributes.walletAddress
                    if Auth.auth().currentUser != nil
                    {
                        let users = db.collection("users").document(Auth.auth().currentUser!.uid)
                        users.updateData(["bitcoinATM" : respData.data.id, "bitcoinWallet" : respData.data.attributes.walletAddress])
                    }
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
        
        // Ether
        let etherParams = """
        {
            "data" : {
                "type" : "asset-transfer-methods",
                "attributes" : {
                    "asset-id" : "\(self.etherID)",
                    "asset-transfer-type" : "ethereum",
                    "contact-id" : "\(self.contactID)",
                    "account-id" :"\(self.accountID)",
                    "transfer-direction" : "incoming",
                    "single-use" : false
                }
            }
        }
        """
        
        let etherPostData = bitcoinParams.data(using: .utf8)
        request.httpBody = etherPostData
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let respData = try JSONDecoder().decode(ATMResponse.self, from: data)
                DispatchQueue.main.async
                {
                    self.etherWallet = respData.data.attributes.walletAddress
                    if Auth.auth().currentUser != nil
                    {
                        let users = db.collection("users").document(Auth.auth().currentUser!.uid)
                        users.updateData(["etherATM" : respData.data.id, "etherWallet" : respData.data.attributes.walletAddress])
                    }
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
        
        // XRP
        let xrpParams = """
        {
            "data" : {
                "type" : "asset-transfer-methods",
                "attributes" : {
                    "asset-id" : "\(self.xrpID)",
                    "asset-transfer-type" : "xrp",
                    "contact-id" : "\(self.contactID)",
                    "account-id" :"\(self.accountID)",
                    "transfer-direction" : "incoming",
                    "single-use" : false
                }
            }
        }
        """
        
        let xrpPostData = xrpParams.data(using: .utf8)
        request.httpBody = xrpPostData
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let respData = try JSONDecoder().decode(ATMResponse.self, from: data)
                DispatchQueue.main.async
                {
                    self.xrpWallet = respData.data.attributes.walletAddress
                    if Auth.auth().currentUser != nil
                    {
                        let users = db.collection("users").document(Auth.auth().currentUser!.uid)
                        users.updateData(["xrpATM" : respData.data.id, "xrpWallet" : respData.data.attributes.walletAddress])
                    }
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
        
        if Auth.auth().currentUser != nil
        {
            let users = db.collection("users").document(Auth.auth().currentUser!.uid)
            users.updateData(["walletsCreated" : true])
        }
    }
}
