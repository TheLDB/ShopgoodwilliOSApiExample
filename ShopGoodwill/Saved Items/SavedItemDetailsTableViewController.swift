//
//  SavedItemDetailsTableViewController.swift
//  ShopGoodwill
//
//  Created by Dylan McDonald on 1/2/22.
//

import UIKit
import WebKit

class SavedItemDetailsTableViewController: UITableViewController, WKNavigationDelegate {

    var myIndex: Int = 0
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var bidsLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var itemDescLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webView.configuration.allowsInlineMediaPlayback = true
        webView.allowsLinkPreview = true
        webView.configuration.allowsPictureInPictureMediaPlayback = true
        webView.configuration.preferences.isFraudulentWebsiteWarningEnabled = true
        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = true
            self.splitViewController?.primaryBackgroundStyle = .sidebar
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
            headerView.backgroundColor = .clear
            self.tableView.tableHeaderView = headerView
        }
//        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = SavedAuctionsTitle(forIndex: myIndex)
        
        let urlString = "https://shopgoodwill.com/shopgoodwill/item/\(SavedAuctionsID(forIndex: myIndex))"
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
        webView.evaluateJavaScript("document.getElementsByClassName('text-decoration-underline d-print-none')[0].innerText;") {(result, error) in
            guard error == nil else {
                print(error!)
                return
            }
            self.bidsLabel.text = String(describing: result!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            #if targetEnvironment(macCatalyst)
            updateTitlebarTitle(with: "Item Details", session: (self.view.window?.windowScene?.session)!)
            #endif
        }
        
    }
    
   
    @objc func goBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
