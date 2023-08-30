//
//  StoresModel.swift
//  Hunter
//
//  Created by iOSayed on 16/08/2023.
//

import Foundation

// MARK: - StoresModel
struct StoresModel: Codable {
    let message: String?
    let data: [StoreObject]!
    let success: Bool?
    let statusCode: Int?
}

// MARK: - StoreObject
struct StoreObject: Codable {
    let companyActivity, companyName, phone, email: String?
    let whatsapp: String?
    let countryID: Int?
    let password: String?
    let userID: Int?
    let bio, logo, license: String?
    let coverPhoto: String?
    let status: String?
    let twitter: String?
    let website: String?
    let googleMap: String?

    enum CodingKeys: String, CodingKey {
        case companyActivity = "company_activity"
        case companyName = "company_name"
        case phone, email, whatsapp
        case countryID = "country_id"
        case password
        case userID = "user_id"
        case bio, logo, license
        case coverPhoto = "cover_photo"
        case status, twitter, website
        case googleMap = "google_map"
    }
}
// MARK: - CreateStoreSuccessfulModel
struct CreateStoreSuccessfulModel: Codable {
    let message: String?
    let data: StoreData!
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct StoreData: Codable {
    let companyName, companyActivity, phone, email: String?
    let whatsapp, countryID, password, bio: String?
    let logo, license: String?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case companyActivity = "company_activity"
        case phone, email, whatsapp
        case countryID = "country_id"
        case password, bio, logo, license
    }
}


// MARK: - CreateStoreFailureModel
struct CreateStoreFailureModel: Codable {
    let message: String?
    let errors: StoresErrors!
}

// MARK: - StoresErrors
struct StoresErrors: Codable {
    let companyName, companyActivity, phone, email: [String]?
    let whatsapp, countryID, password, bio: [String]?
    let logo, license: [String]?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case companyActivity = "company_activity"
        case phone, email, whatsapp
        case countryID = "country_id"
        case password, bio, logo, license
    }
}
