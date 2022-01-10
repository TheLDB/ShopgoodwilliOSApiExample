//
//  BrowseTableViewController.swift
//  ShopGoodwillAPI
//
//  Created by Dylan McDonald on 1/5/22.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var allTitles: [String] = []
    var allPrices: [Float] = []
    var allBidAmounts: [Int] = []
    var allTimeLeft: [String] = []
    var allImageURLs: [String] = []
    var allItemIDs: [Int] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if runningOn == "Mac" {
//            if isSearchBarEmpty {
//                self.view.endEditing(true)
//                self.searchController.searchBar.text = ""
//                UIView.animate(withDuration: 0.3) {
//                    self.navigationController?.isNavigationBarHidden = true
//                }
//            }
//        }
        self.getAuctions(searchText: self.searchController.searchBar.text ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        #if targetEnvironment(macCatalyst)
        updateTitlebarTitle(with: "Search", session:    (self.view.window?.windowScene?.session)!)
            updateTitlebarSubtitle(with: "", session: (self.view.window?.windowScene?.session)!)
        #endif
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let specificSearch = specificSearch()
//        specificSearch.getAuctions(searchText: "iPhone")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.updateData()
//        }
        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.prefersLargeTitles = false
            let label = UILabel()
            label.textColor = .label
            label.text = "Enter Search Term"
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
            self.title = " "
            self.splitViewController?.primaryBackgroundStyle = .sidebar
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
            headerView.backgroundColor = .clear
            self.tableView.tableHeaderView = headerView
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search ShopGoodwill"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
//        if runningOn == "Mac" {
            navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.automaticallyShowsScopeBar = true
//        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTitles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! SearchTableViewCell

        let index = indexPath.row
        
        cell.titleLabel.text = allTitles[index]
        cell.bidsLabel.text = "\(String(allBidAmounts[index])) Bids"
        cell.priceLabel.text = "$\(String(round(allPrices[index] * 100) / 100))"
        cell.daysLeftLabel.text = allTimeLeft[index]
        let url = (URL(string: #"\#(allImageURLs[index])"#) ?? URL(string: #"\#("https://shopgoodwillimages.azureedge.net/production/48/Items/01-02-2022/a34a371e-bf89-4261-a7c1-ee6237b658dfttle_0102t1.jpg")"#))!
        
        cell.mainImage?.load(url: url)
        
        cell.backgroundColor = (index % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground

        return cell
    }
   


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListingDetailsView") as! ItemDetailsTableViewController
        let navView = UINavigationController(rootViewController: listingView)
        navView.navigationItem.largeTitleDisplayMode = .never
        navView.isNavigationBarHidden = false
        navView.navigationBar.prefersLargeTitles = false
        navView.title = title
        listingView.itemID = allItemIDs[indexPath.row]
        self.show(listingView, sender: self)
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    
    // JSON
    struct DecodableType: Decodable { let url: String }
    let url = "https://buyerapi.shopgoodwill.com/api/Search/ItemListing"
    
    
    
    
    func getAuctions(searchText: String) {
//        var toReturn: [String] = []
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let someDateTime = formatter.string(from: currentDateTime)
        //        print(someDateTime)
        
        let aucParams: [String: Any] = [
            "categoryId": 0,
            "categoryLevel": 1,
            "categoryLevelNo": "1", // why is this a string
            "catIds": "",
            "closedAuctionDaysBack": "7", // string???????
            "closedAuctionEndingDate": someDateTime,
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
            
            
            "searchText": searchText, // Yes, its as simple as this
            
            
            "searchUSOnlyShipping": "false",
            "selectedCategoryIds": "",
            "selectedGroup": "",
            "selectedSellerIds": "",
            "sortColumn": "1",
            "sortDescending": "false",
            "useBuyerPrefs": "true"
        ]
        AF.request(url, method: .post, parameters: aucParams, encoding: JSONEncoding.default).responseDecodable(of: DecodableType.self) { [self] response in
            do {
                let json = try JSON(data: response.data!) // Uses JSONSwifty to parse JSON
                
                let specificAuctionResults = json["searchResults"]["items"] // Gets only the stuff we need from the results
                
                allTitles = []
                allPrices = []
                allBidAmounts = []
                allTimeLeft = []
                allImageURLs = []
                
                specificAuctionResults.forEach({
                    // $0.1 = Value
                    // $0.0 = Key
                    let JSONN = String(describing: $0.1)
                    let jsonData = JSONN.data(using: .utf8)!
                    let listingInfo: BrowseListingInfo = try! JSONDecoder().decode(BrowseListingInfo.self, from: jsonData)
                    allTitles.append(listingInfo.title)
                    allPrices.append(listingInfo.currentPrice)
                    allBidAmounts.append(listingInfo.numBids)
                    allTimeLeft.append(listingInfo.remainingTime)
                    allImageURLs.append(listingInfo.imageURL.replacingOccurrences(of: "\\", with: "/"))
                    allItemIDs.append(listingInfo.itemId)
                })
                self.tableView.reloadData()
            }
            catch {
                print(error) // Catch any errors (like goodwill being down)
            }
        }
    }
    
    
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        filterContentForSearchText(searchBar.text!)
    }
}

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bidsLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView?
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
