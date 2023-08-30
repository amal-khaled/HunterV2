//
//  StoresController.swift
//  Hunter
//
//  Created by iOSayed on 28/08/2023.
//

import Foundation
import UIKit
import Alamofire
import MOLH


class StoresController {
    static let shared = StoresController()
    
    func getStores(completion: @escaping([StoreObject], Int, String)->(),countryId:Int){
        
        let params = [
            "country_id": countryId
        ]
        APIConnection.apiConnection.getConnectionWithParam(completion: { data in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(StoresModel.self, from: data)
                
                if productArray.statusCode == 200{
                    
                    completion(productArray.data, 0,"")
                }
                else {
                    completion([StoreObject](),1,productArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([StoreObject](),1,SERVER_ERROR)
                
                
            }
        }, link: Constants.HOME_STORES_URL,param:params)
    }
    
    func createStore(fullname: String, mobile: String, whatsAppNum: String, email: String, activity: String, countryCode: Int, password: String, bio: String, logoImage: Data, licenseImage: Data, completion: @escaping (Data?) -> Void) {

        // API Endpoint
        let url = Constants.HOME_STORES_URL
        
        let param = [
            "company_name":fullname,
            "company_activity":activity,
            "phone":mobile,
            "email":email,
            "whatsapp":whatsAppNum,
            "country_id":countryCode,
            "password":password,
            "bio":bio
        ] as [String : Any]
        // Header
        var headers: HTTPHeaders =
        [
            "OS": "ios",
            "Accept":"application/json",
            "Content-Lang": MOLHLanguage.currentAppleLanguage()
            //         "App-Version": version as! String,
            //         "Os-Version": UIDevice.current.systemVersion
        ]
        print(AppDelegate.currentUser.toke)
        if AppDelegate.currentUser.toke != "" && AppDelegate.currentUser.toke != nil{
            headers["Authorization"] = "Bearer \(AppDelegate.currentUser.toke ?? "")"
        }
        
        // Alamofire Request
        print(param)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(), withName: "logo", fileName: "logo.png", mimeType: "image/png")
            multipartFormData.append(licenseImage, withName: "license", fileName: "license.png", mimeType: "image/png")
            
            for (key,value) in param {
                multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, headers: headers)
        .responseJSON { response in
            print(response.result)
            print("=============================================")
            if let JSON = response.data {
                completion(JSON)
            }
            
            else {
                completion(nil)
            }
        }
    }
    
    
}
