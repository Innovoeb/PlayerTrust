//
//  UploadDocuments_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/18/21.
//

import SwiftUI

struct UploadDocuments: View
{
    @EnvironmentObject var user: User
    
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var image: UIImage?
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                // either used chosen image or our placeholder image
                Image(uiImage: image ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 300, height: 300)
                
                Button("Choose Picture")
                {
                    self.showSheet = true
                }
                .padding()
                .actionSheet(isPresented: $showSheet)
                {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [.default(Text("Photo Library"))
                    {
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    },
                    .default(Text("Camera"))
                    {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    },
                    .cancel()
                    ])
                }
                
                Spacer()
                Button("Submit")
                {
                    postImage()
                }
                
                Spacer()
                AccountHomeButton()
            }
            .navigationBarTitle("Upload ID")
        }
        .sheet(isPresented: $showImagePicker)
        {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
        .onTapGesture
        {
            print("contactID: \(user.contactID)")
            if (image != nil)
            {
                print(image!)
            }
        }
        .onAppear()
        {
            user.getCurrentUserDocument()
        }
    }
    
    // MARK: Smoke and Mirrors
    func postImage()
    {
        // create a timer for 2mins that uses PT sandbox endpoint that opens the account
        Timer.scheduledTimer(withTimeInterval: 45.0, repeats: false)
        { timer in
            user.openAccount()
            user.accountIsOpen = true
        }
        
        // navigate end user to account home
        let window = UIApplication.shared.windows.first
        window?.rootViewController = UIHostingController(rootView: AccountHome().environmentObject(User()))
        window?.makeKeyAndVisible()
    }
    
}

struct UploadDocuments_V_Previews: PreviewProvider {
    static var previews: some View {
        UploadDocuments()
    }
}
