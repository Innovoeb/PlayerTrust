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
    @Published var bitcoinWallet = ""
    @Published var etherWallet = ""
    @Published var xrpWallet = ""
    
    // User.openAccount()
    var kycDocCheckID = ""
    var cipCheckID = ""
    
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
    
    // PlayerTrust Wallet
    @Published var cointype = ""
    @Published var amount = ""
    @Published var outgoingWallet = ""
    var assetTransferID = ""
    var disbursementEmailLink = ""
    var disbursementEmailID = ""
    //@Published var assetTotals = [AssetBalance]()
    @Published var bitcoinTotal = 0.0
    @Published var etherTotal = 0.0
    @Published var xrpTotal = 0.0
    
    // progress views
    @Published var assetBalanceIsLoading = false
    @Published var accountHomeIsLoading = false
    @Published var playerauthDetailIsLoading = false
    @Published var walletAddressesAreLoading = false
    
    init()
    {
        userLoggedIn = Auth.auth().currentUser == nil ? false : true // check if a user is logged in
        if (userLoggedIn == true)
        {
            getCurrentUserDocument()
        }
    }
    
    // get firestore document related to current user
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
    
    // grab the associated PT account's status
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
    
    // grab the associated PT contact's info
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
                            self.playerauthDetailIsLoading = false
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
    
    // smoke and mirrors method that opens PT account and clears/verifys cip and kyc doc checks
    func openAccount()
    {
        self.sandboxOpen()
        print("init...")
        print("contactID: \(self.contactID), accountID: \(self.accountID)")
        
        // fire off methods within a few seconds of eachother
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false)
        { timer in
            
            self.createKYCDocCheck()
            print("1st timer fired!")
        }
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false)
        { timer in
            
            self.approveKYCDocCheck()
            print("2nd timer fired!")
            print("kyc check: \(self.kycDocCheckID)")
        }
        Timer.scheduledTimer(withTimeInterval: 90.0, repeats: false)
        { timer in
            
            self.getCIPChecks()
            print("3rd timer fired!")
        }
        Timer.scheduledTimer(withTimeInterval: 120.0, repeats: false)
        { timer in
            
            self.approveCIPCheck()
            print("4th timer fired!")
            print("cip check: \(self.cipCheckID)")
        }
    }
    
    func sandboxOpen()
    {
        var request = URLRequest(url: URL(string: "https://sandbox.primetrust.com/v2/accounts/\(self.accountID)/sandbox/open")!,timeoutInterval: Double.infinity)
                request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request)
                {
                    (data, response, error) in
                    
                    if error != nil
                    {
                        print(String(describing: error))
                    }
                }
                task.resume()
    }
    
    // create PT kyc doc check associated with contactID
    func createKYCDocCheck()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)kyc-document-checks")!,timeoutInterval: Double.infinity)
        
        let parameters = """
        {
          "data": {
            "type": "kyc-document-checks",
            "attributes": {
              "contact-id": "\(self.contactID)",
              "uploaded-document-id": "\(Constants.logoID)",
              "kyc-document-type": "drivers_license",
              "kyc-document-country": "US"
            }
          }
        }
        """
        let postData = parameters.data(using: .utf8)
        request.httpBody = postData
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let resp = try JSONDecoder().decode(KYCDocCheckResponse.self, from: data)
                DispatchQueue.main.async
                {
                    self.kycDocCheckID = resp.data.id
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
    func getCIPChecks()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)cip-checks?contact.id=\(self.contactID)")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let resp = try JSONDecoder().decode(GetCIPCheck.self, from: data)
                DispatchQueue.main.async
                {
                    self.cipCheckID = resp.data[0].id
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
    func approveKYCDocCheck()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)kyc-document-checks/\(self.kycDocCheckID)/sandbox/verify")!,timeoutInterval: Double.infinity)
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
    
    func approveCIPCheck()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)cip-checks/\(self.cipCheckID)/sandbox/approve")!,timeoutInterval: Double.infinity)
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data, response, error) in
            
            if error != nil
            {
                print(String(describing: error))
                return
            }
        }
        task.resume()
    }
    
    // change bool in user's firestore document to true after an image is uploaded
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
        
        let etherPostData = etherParams.data(using: .utf8)
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
    
    
    func coinWithdraw()
    {
        self.createAssetDisbursement()
        print("init...")
        print("asset disbursement created")
        
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false)
        { timer in
            
            self.getDisbursementEmail()
            print("1st timer fired!")
        }
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false)
        { timer in
            
            self.approveDisbursementEmail()
            print("2nd timer fired!")
        }
        Timer.scheduledTimer(withTimeInterval: 90.0, repeats: false)
        { timer in
            
            self.settleAssetTransfer()
            print("3rd timer fired!")
        }
    }
    
    func createAssetDisbursement()
    {
        var coinID = ""
        
        if (self.cointype == "bitcoin")
        {
            coinID = self.bitcoinID
        }
        else if (self.cointype == "ethereum")
        {
            coinID = self.etherID
        }
        else if (self.cointype == "xrp")
        {
            coinID = self.xrpID
        }
        
        print("----------coinID: \(coinID)")
        
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)asset-disbursements?include=asset-transfer")!,timeoutInterval: Double.infinity)
        
        let parameters = """
            {
              "data": {
                "type": "asset-disbursements",
                "attributes": {
                  "account-id": "\(self.accountID)",
                  "unit-count": "\(self.amount)",
                  "asset-transfer-method": {
                      "asset-id": "\(coinID)",
                      "asset-transfer-type": "\(self.cointype)",
                      "contact-id": "\(self.contactID)",
                      "account-id": "\(self.accountID)",
                      "transfer-direction": "outgoing",
                      "wallet-address": "\(self.outgoingWallet)"
                    }
                }
              }
            }
        """
        let postData = parameters.data(using: .utf8)
        request.httpBody = postData
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
          
            guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let resp = try JSONDecoder().decode(CreateAssetDisbursement.self, from: data)
                DispatchQueue.main.async
                {
                    self.assetTransferID = resp.included[0].id
                    self.disbursementEmailLink = resp.data.relationships.disbursementAuthorization.links.related
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
    func getDisbursementEmail()
    {
        var request = URLRequest(url: URL(string: "https://sandbox.primetrust.com\(self.disbursementEmailLink)")!,timeoutInterval: Double.infinity)
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
          
            guard let data = data else {
            print(String(describing: error))
            return
          }
            do
            {
                let resp = try JSONDecoder().decode(GetDisbursementEmail.self, from: data)
                DispatchQueue.main.async
                {
                    self.disbursementEmailID = resp.data.id
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
    func approveDisbursementEmail()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)disbursement-authorizations/\(self.disbursementEmailID)/sandbox/verify-owner")!,timeoutInterval: Double.infinity)
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data, response, error) in
            
            if error != nil
            {
                print(String(describing: error))
            }
        }
        task.resume()
    }
    
    func settleAssetTransfer()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)asset-transfers/\(self.assetTransferID)/sandbox/settle")!,timeoutInterval: Double.infinity)
        request.setValue("Bearer \(Constants.JWT)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data, response, error) in
            
            if error != nil
            {
                print(String(describing: error))
            }
        }
        task.resume()
    }
    
    func getAssetBalance()
    {
        var request = URLRequest(url: URL(string: "\(Constants.primetrustURL)account-asset-totals?account.id=\(self.accountID)")!)
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
                let respData = try JSONDecoder().decode(AssetBalance.self, from: data)
                DispatchQueue.main.async
                {
                    self.assetBalanceIsLoading = false
                    for i in 0..<respData.data.count
                    {
                        if (respData.data[i].attributes.name == "bitcoin")
                        {
                            self.bitcoinTotal += respData.data[i].attributes.disbursable
                        }
                        if (respData.data[i].attributes.name == "ether")
                        {
                            self.etherTotal += respData.data[i].attributes.disbursable
                        }
                        if (respData.data[i].attributes.name == "xrp")
                        {
                            self.xrpTotal += respData.data[i].attributes.disbursable
                        }
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
    
    
}
