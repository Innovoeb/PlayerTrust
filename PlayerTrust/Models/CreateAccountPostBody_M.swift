//
//  CreateAccountResponse_M.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/18/21.
//

import SwiftUI

struct CreateAccountPostBody: Codable
{
    let data: Data
}

struct Data: Codable
{
    let type: String
    let attributes: Attributes
}

struct Attributes: Codable
{
    let accountType: String
    let name: String
    let authorizedSignature: String
    let owner: Owner
    let webhookConfig: WebhookConfig
    
    enum CodingKeys: String, CodingKey
    {
        case accountType = "account-type"
        case authorizedSignature = "authorized-signature"
        case webhookConfig = "webhook-config"
        
        case name
        case owner
    }
    
}

struct Owner: Codable
{
    let contactType: String
    let name: String
    let email: String
    let DOB: String
    let SSN: String
    let country: String
    let phoneNumber: PhoneNumber
    let address: Address
    
    enum CodingKeys: String, CodingKey
    {
        case contactType = "contact-type"
        case DOB = "date-of-birth"
        case SSN = "tax-id-number"
        case country = "tax-country"
        case phoneNumber = "primary-phone-number"
        case address = "primary-address"
        
        case name
        case email
    }
}

struct PhoneNumber: Codable
{
    let country: String
    let number: String
    let sms: Bool
    
}

struct Address: Codable
{
    let street1: String
    let street2: String
    let postalCode: String
    let city: String
    let state: String
    let country: String
    
    enum CodingKeys: String, CodingKey
    {
        case street1 = "street-1"
        case street2 = "street-2"
        case postalCode = "postal-code"
        case state = "region"
        
        case city
        case country
    }
}

struct WebhookConfig: Codable
{
    let email: String
    let url: String
    let enabled: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case email = "contact-email"
        
        case url
        case enabled
    }
}

