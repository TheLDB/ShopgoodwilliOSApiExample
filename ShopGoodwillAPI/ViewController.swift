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
//        let importGetAllAuctions = getAllAuctions()
//        let importSpecificSearch = specificSearch()
        let importOpenOrders = getOpenOrders()
//        importGetAllAuctions.getAuctions()
        importOpenOrders.getOpenOrders()
	}
}

