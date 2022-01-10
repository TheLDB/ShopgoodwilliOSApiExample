//
//  ItemDetailsTableViewController.swift
//  ShopGoodwillAPI
//
//  Created by Dylan McDonald on 1/9/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class ItemDetailsTableViewController: UITableViewController {

    var itemID: Int = 0
    
    // Main Info
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bidsLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    // Item Details
    @IBOutlet weak var itemIDLabel: UILabel!
    @IBOutlet weak var numberOfBidsLabel: UILabel!
    @IBOutlet weak var bidIncrementLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        getOneItem(itemID: itemID)
        self.navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        #if targetEnvironment(macCatalyst)
            updateTitlebarTitle(with: "Listing Details", session:    (self.view.window?.windowScene?.session)!)
            updateTitlebarSubtitle(with: "Loading...", session: (self.view.window?.windowScene?.session)!)
        #endif
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = true
            self.splitViewController?.primaryBackgroundStyle = .sidebar
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
            headerView.backgroundColor = .clear
            self.tableView.tableHeaderView = headerView
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var toReturn: CGFloat!
        switch section {
        case 0:
            toReturn = 0
        case 1:
            toReturn = 4
        case 2:
            toReturn = 4
        default:
            toReturn = UITableView.automaticDimension
        }
        return toReturn
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var toReturn: CGFloat!
        switch section {
        case 2:
            toReturn = 4
        case 3:
            toReturn = 4
        default:
            toReturn = UITableView.automaticDimension
        }
        return toReturn
    }
    
    @objc func goBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    // Get Data
    struct DecodableType: Decodable { let url: String }
    func getOneItem(itemID: Int) {
        let url = "https://buyerapi.shopgoodwill.com/api/ItemDetail/GetItemDetailModelByItemId/\(itemID)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseDecodable(of: DecodableType.self) { [self]
            response in
            do {
                let json = try JSON(data: response.data!)
                
                let JSONN = String(describing: json)
                let jsonData = JSONN.data(using: .utf8)!
                let listingInfo: SingleListing = try! JSONDecoder().decode(SingleListing.self, from: jsonData)
                tableView.beginUpdates()
                titleLabel.text = listingInfo.title
                bidsLabel.text = "\(String(listingInfo.numberOfBids)) Bids"
                priceLabel.text = "$\(String(round(listingInfo.currentPrice * 100) / 100))"
                daysLeftLabel.text = listingInfo.remainingTime
                
                itemIDLabel.text = String(describing: itemID)
//                numberOfBidsLabel.text = String(describing: listingInfo.)
                bidIncrementLabel.text = "$\(String(round(listingInfo.bidIncrement * 100) / 100))"
                endDateLabel.text = listingInfo.endTime
                sellerNameLabel.text = listingInfo.sellerCompanyName
                itemDescriptionLabel.text = listingInfo.description
                
                if priceLabel.text?.suffix(2) == ".0" {
                    priceLabel.text = "\(priceLabel.text!)0"
                }
                if bidIncrementLabel.text?.suffix(2) == ".0" {
                    bidIncrementLabel.text = "\(bidIncrementLabel.text!)0"
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                #if targetEnvironment(macCatalyst)
                    updateTitlebarSubtitle(with: listingInfo.title, session: (self.view.window?.windowScene?.session)!)
                #endif
                }
                tableView.endUpdates()
            }
            catch {
                print(error)
            }
        }
    }
    
}
