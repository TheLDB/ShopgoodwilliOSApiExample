//
//  oneItem.swift
//  ShopGoodwillAPI
//
//  Created by Landon Boles on 1/9/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class oneItem {
    
    struct DecodableType: Decodable { let url: String }
    func getOneItem(itemID: Int) {
        let url = "https://buyerapi.shopgoodwill.com/api/ItemDetail/GetItemDetailModelByItemId/\(itemID)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: DecodableType.self) {
            response in
            do {
                let json = try JSON(data: response.data!)
                print("***")
                print(json)
            }
            catch {
                print(error)
            }
        }
    }
}
