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
                
                HStack (spacing: 10)
                {
                    Image(systemName: "plus")
                    Text("Select Picture")
                }
                .onTapGesture
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
                HStack (spacing: 10)
                {
                    Image(systemName: "chevron.right.2")
                    Text("Submit")
                }
                .onTapGesture
                {
                    postImage()
                }
                
                Spacer()
                // MARK: TODO: Make an Alert Here!
                HStack (spacing: 65)
                {
                    AccountHomeButton()
                    LogoutButton()
                }
            }
            .navigationBarTitle("Upload Identification")
        }
        .sheet(isPresented: $showImagePicker)
        {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
        .onAppear()
        {
            //user.getCurrentUserDocument()
        }
    }
    
    // MARK: Smoke and Mirrors!
    func postImage()
    {
        user.imageWasUploaded()
        user.getCurrentUserDocument()
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { Timer in
            
            user.openAccount()
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
