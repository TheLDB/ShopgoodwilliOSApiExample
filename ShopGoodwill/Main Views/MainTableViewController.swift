//
//  ViewController.swift
//  ShopGoodwill
//
//  Created by Dylan McDonald on 1/1/22.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBOutlet weak var AuctionsInProgressCell: StandardTableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        getSavedAuctions()
//        tableView.beginUpdates()
        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = true
            self.splitViewController?.primaryBackgroundStyle = .sidebar
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
            headerView.backgroundColor = .clear
            self.tableView.tableHeaderView = headerView
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
//        tableView.endUpdates()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func goBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url: String = ""
        var title: String = ""
        
        switch indexPath.section {
        case 3:
            url = "inprogress-auctions"
            title = "Auctions In Progress"
        case 4:
            url = "closed-auctions"
            title = "Closed Auctions"
        case 5:
            url = "open-orders"
            title = "Open Orders"
        case 6:
            url = "shipped-orders"
            title = "Shipped Orders"
        case 7:
            url = "favorites"
            title = "Favorites"
        case 8:
            url = "personal-shopper-list"
            title = "Personal Shopper"
        case 9:
            url = "saved-searches"
            title = "Saved Searches"
        case 10:
            url = "customer-service"
            title = "Customer Service"
        case 11:
            url = "pickup-schedule"
            title = "Pickup Schedule"
        default:
            url = "home"
            title = "Home"
        }
        
        if url != "home" {
            let webView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainWebView") as! MainWebViewController
            let navView = UINavigationController(rootViewController: webView)
            navView.navigationItem.largeTitleDisplayMode = .never
            navView.isNavigationBarHidden = false
            navView.navigationBar.prefersLargeTitles = false
            navView.title = title
            webView.urlToLoad = url
            webView.titleToSet = title
            self.showDetailViewController(navView, sender: self)
        }
    }
}

class StandardTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backView = UIView()
        backView.frame = self.frame
        backView.backgroundColor = self.backgroundColor
        backView.clipsToBounds = true
        backView.layer.cornerCurve = .continuous
        backView.layer.cornerRadius = 10
        self.backgroundView = backView
        self.backgroundColor = .clear
        
        self.contentView.layer.cornerCurve = .continuous
        self.contentView.layer.cornerRadius = 10
        
        self.selectedBackgroundView?.layer.cornerCurve = .continuous
        self.selectedBackgroundView?.layer.cornerRadius = 10
    }
}

class SidebarTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backView = UIView()
        backView.frame = self.frame
            backView.backgroundColor = runningOn == "Mac" ? .none : self.backgroundColor
        backView.clipsToBounds = true
        backView.layer.cornerCurve = .continuous
        backView.layer.cornerRadius = 10
        self.backgroundView = backView
        self.backgroundColor = .clear
        
        self.contentView.layer.cornerCurve = .continuous
        self.contentView.layer.cornerRadius = 10
        
        self.selectedBackgroundView?.layer.cornerCurve = .continuous
        self.selectedBackgroundView?.layer.cornerRadius = 10
    }
}
