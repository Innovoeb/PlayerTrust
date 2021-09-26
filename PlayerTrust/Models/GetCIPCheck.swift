//
//  GetCIPCheck.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/25/21.
//

import Foundation
import SwiftUI

struct GetCIPCheck: Codable
{
    let data: [CIPCheckData]
}

struct CIPCheckData: Codable
{
    let id: String
}
