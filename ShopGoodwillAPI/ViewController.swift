//
//  ViewController.swift
//  ShopGoodwillAPI
//
//  Created by Landon Boles on 1/3/22.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		struct DecodableType: Decodable { let url: String } // Decodable Type enforced by Alamofire
		let url = "https://buyerapi.shopgoodwill.com/api/Search/ItemListing" // URL for Open Auctions
		let aucParams: [String: Any] = [ // All the parameters to get all open auctions
				"categoryId": 0,
				"categoryLevel": 1,
				"categoryLevelNo": "1", // why is this a string
				"catIds": "",
				"closedAuctionDaysBack": "7", // string???????
				"closedAuctionEndingDate": "1/3/2022",
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
		AF.request(url, method: .post, parameters: aucParams, encoding: JSONEncoding.default) // Makes a request to our url above, using our above params, and uses JSON encoding
			.responseDecodable(of: DecodableType.self) { response in
			  if response.data != nil { // Makes sure the data exists
				  do {
					  let json = try JSON(data: response.data!) // SwiftyJSON stuff to parse
					  let test = json["searchResults"]["items"] // Just gets the stuff we actually need
					  test.forEach({ // For each item returned (should be 39 due to our params)
						  // $0.0 = Key (1, 2, 3, 4, basically just the item number
						  // $0.1 = Value (all the meat and stuff like title, bid, etc..
						  if($0.0 == "36") {
							  print("thirty six")
						  }
						  else {
							  print($0.1)
							  // You can take the values from this and put it into dynamic cells, buyNowPrice, categoryID, etc...
						  }
					  })
				  }
				  catch {
					  print(error)
				  }
			  }
		  }
	}


}

