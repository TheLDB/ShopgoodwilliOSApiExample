//
//  getAllAuctions.swift
//  ShopGoodwillAPI
//
//  Created by Landon Boles on 1/5/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class getAllAuctions {
    struct DecodableType: Decodable { let url: String }
    let url = "https://buyerapi.shopgoodwill.com/api/Search/ItemListing"
    let aucParams: [String: Any] = [
        "categoryId": 0,
        "categoryLevel": 1,
        "categoryLevelNo": "1", // why is this a string
        "catIds": "",
        "closedAuctionDaysBack": "7", // string???????
        "closedAuctionEndingDate": "1/5/2022",
        "highPrice": "999999", // why.. what???
        "isFromHeaderMenuTab": false,
        "isMultipleCategoryIds": false,
        "isSize": false,
        "isWeddingCatagory": "false",
        "layout": "",
        "lowPrice": "0",
        "page": "1",
        "pageSize": "40",
        "partNumber": "",
        "savedSearchId": 0,
        "searchBuyNowOnly": "",
        "searchCanadaShipping": "false", // i hate it here
        "searchClosedAuctions": "false", // ^
        "searchDescriptions": "false",
        "searchInternationalShippingOnly": "false",
        "searchNoPickupOnly": "false",
        "searchOneCentShippingOnly": "false",
        "searchPickupOnly": "false",
        "searchText": "",
        "searchUSOnlyShipping": "false",
        "selectedCategoryIds": "",
        "selectedGroup": "",
        "selectedSellerIds": "",
        "sortColumn": "1",
        "sortDescending": "false",
        "useBuyerPrefs": "true"
    ]
    
    func getAuctions() {
        AF.request(url, method: .post, parameters: aucParams, encoding: JSONEncoding.default).responseDecodable(of: DecodableType.self) { response in
                do {
                    let json = try JSON(data: response.data!) // Uses JSONSwifty to parse JSON
                    
                    let specificAuctionResults = json["searchResults"]["items"] // Gets only the stuff we need from the results
                    
                    specificAuctionResults.forEach({
                        // $0.1 = Value
                        // $0.0 = Key
                        print($0.1)
                    })
                }
                catch {
                    print(error) // Catch any errors (like goodwill being down)
                }
            }
    }
}
