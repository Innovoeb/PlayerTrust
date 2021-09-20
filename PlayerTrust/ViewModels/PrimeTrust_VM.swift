//
//  PrimeTrust_VM.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/18/21.
//

import SwiftUI

class PrimeTrust: ObservableObject
{
    @Published var name = ""
    @Published var DOB = ""
    @Published var SSN = ""
    
    @Published var street1 = ""
    @Published var street2 = ""
    @Published var postalCode = ""
    @Published var city = ""
    @Published var state = ""
    
    @Published var foobar = "This is from the PT viewmodel"
    
    init()
    {
        
    }
    
    
    
    
    
    
}
