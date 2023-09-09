//
//  PayingController.swift
//  Hunter
//
//  Created by iOSayed on 09/09/2023.
//

import Foundation

class PayingController {
    
    static let shared = PayingController()
    
    func payingFeaturedAd(completion: @escaping(PayingAdModel?, Int, String)->(),countryId:Int,productId:Int){
            
            let params = [
                "country_id": countryId
            ]
            APIConnection.apiConnection.postConnection(completion: { data in
                guard let data = data else { return }
                
                do {
                    let payingObj = try JSONDecoder().decode(PayingAdModel.self, from: data)
                    
                    if payingObj.statusCode == 200{
                        
                        completion(payingObj, 0,"")
                    }
                    else {
                        completion(nil,1,payingObj.message ?? "")
                    }
                    
                } catch (let jerrorr){
                    
                    print(jerrorr)
                    completion(nil,1,SERVER_ERROR)
                    
                    
                }
            }, link: Constants.PAYING_FEATURED_AD_URL+"\(productId)",param:params)
        }
    
    
    
}
