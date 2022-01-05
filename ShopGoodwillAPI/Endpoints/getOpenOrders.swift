//
//  getOpenOrders.swift
//  ShopGoodwillAPI
//
//  Created by Landon Boles on 1/5/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class getOpenOrders {
    struct DecodableType: Decodable { let url: String }
    let url = "https://buyerapi.shopgoodwill.com/api/OpenOrders/GetOpenOrders"
    let token = "Bearer eyJh......."
    
    func getOpenOrders() {
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: DecodableType.self) { response in
            do {
                let json = try JSON(data: response.data!)
                
                print(json)
            }
            catch {
                print(error)
            }
        }
    }
    
}
