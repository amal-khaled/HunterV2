//
//  User.swift
//  Hunter
//
//  Created by Amal Elgalant on 29/04/2023.
//


import Foundation


struct UserArrayPaging: Codable{
    var data: UserArray!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}

struct UserArray: Codable{
    var data: [User]!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
struct UserLoginObject: Codable{
    var data: User!
    var code: Int!
    var msg: String!
    var token: String!

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
        case token = "accessToken"

    }
    
    
}
struct UserTokenObject: Codable{
    var data: UserObject!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}


struct UserObject: Codable{
    var data: User!
   
    var token: String!
    enum CodingKeys: String, CodingKey {
        case data = "user"
        case token = "token"
    }
    
    
}



struct User: Codable {
    var id: Int?
    var name, lastName, username, pass: String?
    var loginMethod, uid, bio, phone: String?
    var email: String?
    var countryId, cityId, regionId: Int?
    var pic: String?
    var cover, regid: String?
    var  verified, blocked: Int?
    var typeMob:String?
    var notification, deactivate: Int?
    var note, passV: String?
    var isAdvertiser: Int?
    var countriesNameAr, countriesNameEn, citiesNameAr, citiesNameEn: String?
    var regionsNameAr, regionsNameEn: String?
    var numberOfProds, following, followers, userRate: Int?
    var searchIsFollow, isFollow, activeNotification: Int?
    var toke: String?
    var codeVerify:Int?
    var isStore: Bool?
    var store: Store?
    var availableAdsCountUserInCurrentMonth, availableAdsCountStoreInCurrentMonth: Int?
    var plan: Plan?
    enum CodingKeys: String, CodingKey {
        case id, name
        case lastName = "last_name"
        case username, pass
        case loginMethod = "login_method"
        case uid, bio, email
        case  phone = "mobile"
        case countryId = "country_id"
        case cityId = "city_id"
        case regionId = "region_id"
        case pic, cover, regid
        case typeMob = "type_mob"
        case verified, blocked
        case codeVerify = "code_verify"
        case notification, deactivate, note
        case passV = "pass_v"
        case isAdvertiser = "is_advertiser"
        case countriesNameAr = "countries_name_ar"
        case countriesNameEn = "countries_name_en"
        case citiesNameAr = "cities_name_ar"
        case citiesNameEn = "cities_name_en"
        case regionsNameAr = "regions_name_ar"
        case regionsNameEn = "regions_name_en"
        case numberOfProds
        case following = "Following"
        case followers = "Followers"
        case userRate = "UserRate"
        case searchIsFollow = "follow"
        case isFollow = "is_follow"
        case activeNotification = "active_notification"
        case isStore = "is_store"
        case store
        case availableAdsCountUserInCurrentMonth = "available_ads_count_user_in_current_month"
        case availableAdsCountStoreInCurrentMonth = "available_ads_count_store_in_current_month"
        case plan
    }
}

struct Store: Codable {
    var id: Int?
    var companyName, companyActivity, phone, email: String?
    var whatsapp: String?
    var countryNameAr: CountryNameArObject?
    var countryNameEn: CountryNameEnObject?
    var cityNameAr, cityNameEn, regionNameAr, regionNameEn: String?
    var bio, logo, license: String?
    var twitter, instagram, website, googleMap: String?
    var coverPhoto: String?

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case companyActivity = "company_activity"
        case phone, email, whatsapp
        case countryNameAr = "country_name_ar"
        case countryNameEn = "country_name_en"
        case cityNameAr = "city_name_ar"
        case cityNameEn = "city_name_en"
        case regionNameAr = "region_name_ar"
        case regionNameEn = "region_name_en"
        case bio, logo, license, twitter, instagram, website
        case googleMap = "google_map"
        case coverPhoto = "cover_photo"
    }
}

// MARK: - Plan
struct Plan: Codable {
    var id: Int?
    var nameEn, nameAr, pricePerMonth, durationPerDay: String?
    var adsCount: Int?
    var bestSeller, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case pricePerMonth = "price_per_month"
        case durationPerDay = "duration_per_day"
        case adsCount = "ads_count"
        case bestSeller = "best_seller"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CountryNameAr
struct CountryNameArObject: Codable {
    let nameAr, name: String?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case nameAr = "name_ar"
        case name, currency
    }
}

// MARK: - CountryNameEn
struct CountryNameEnObject: Codable {
    let nameEn: String?
    let name, currency: String?

    enum CodingKeys: String, CodingKey {
        case nameEn = "name_en"
        case name, currency
    }
}
