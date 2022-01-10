//
//  MainWebViewController.swift
//  ShopGoodwill
//
//  Created by Dylan McDonald on 1/2/22.
//

import Foundation
import WebKit
import UIKit
import SPAlert

let accentColor = UIColor(named: "AccentColor")

class MainWebViewController: UIViewController, WKNavigationDelegate {
    
    var urlToLoad: String = "home"
    var titleToSet: String = "Home"
    
    @IBOutlet weak var addToSavedButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = !(self.splitViewController?.traitCollection.horizontalSizeClass == .compact)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        webView.navigationDelegate = self
        addToSavedButton.isHidden = true
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        
        addToSavedButton.layer.cornerRadius = addToSavedButton.frame.height / 2
        backButton.layer.cornerRadius = 15
        forwardButton.layer.cornerRadius = 15
        reloadButton.layer.cornerRadius = 15
        
        addToSavedButton.layer.shadowRadius = 4
        addToSavedButton.layer.shadowOpacity = 0.3
        addToSavedButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        backButton.layer.shadowRadius = 4
        backButton.layer.shadowOpacity = 0.3
        backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        forwardButton.layer.shadowRadius = 4
        forwardButton.layer.shadowOpacity = 0.3
        forwardButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        reloadButton.layer.shadowRadius = 4
        reloadButton.layer.shadowOpacity = 0.3
        reloadButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.view.overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlString = "https://shopgoodwill.com/shopgoodwill/\(urlToLoad)"
        
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
        webView.configuration.allowsInlineMediaPlayback = true
        webView.allowsLinkPreview = true
        webView.configuration.allowsPictureInPictureMediaPlayback = true
        webView.configuration.preferences.isFraudulentWebsiteWarningEnabled = true
       
        self.navigationItem.title = titleToSet
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        #if targetEnvironment(macCatalyst)
            updateTitlebarTitle(with: self.titleToSet, session: (self.view.window?.windowScene?.session)!)
        #endif
        }
        
    }
    
    @IBAction func reload(_ sender: Any) {
        webView.reload()
        checkBackForwardButtons()
    }
    
    @IBAction func goForward(_ sender: Any) {
        self.webView.goForward()
        checkBackForwardButtons()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.webView.goBack()
        checkBackForwardButtons()
    }
    
    func checkBackForwardButtons() {
        if webView.canGoBack == true {
            backButton.tintColor = accentColor
            backButton.isEnabled = true
        } else {
            backButton.tintColor = .systemGray
            backButton.isEnabled = false
        }
        if webView.canGoForward == true {
            forwardButton.tintColor = accentColor
            forwardButton.isEnabled = true
        } else {
            forwardButton.tintColor = .systemGray
            forwardButton.isEnabled = false
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "r", modifierFlags: .command, action: #selector(commandReload), discoverabilityTitle: "Reload Page"),
            UIKeyCommand(input: "[", modifierFlags: .command, action: #selector(commandGoBack), discoverabilityTitle: "Go Back"),
            UIKeyCommand(input: "]", modifierFlags: .command, action: #selector(commandGoForward), discoverabilityTitle: "Go Forward")
        ]
    }
    
    @objc func commandReload() {
        checkBackForwardButtons()
        webView.reload()
    }
    
    @objc func commandGoBack() {
        checkBackForwardButtons()
        webView.goBack()
        
    }
    
    @objc func commandGoForward() {
        checkBackForwardButtons()
        webView.goForward()
    }
    
    
    @IBAction func addToSaved(_ sender: Any) {
        var itemTitle: String = ""
//        var endDate: String = ""
        let id = "\(String(describing: webView.url!))".replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "shopgoodwill.com", with: "").replacingOccurrences(of: "/item/", with: "")

        // Get title
        webView.evaluateJavaScript("document.getElementById('\(id)').innerText;") {(result, error) in
            guard error == nil else {
                print(error!)
                return
            }
            itemTitle = String(describing: result!)
        }
        
//        // Get end date
//        webView.evaluateJavaScript("document.getElementsByClassName('col-4 text-right')[0].innerText;") {(result, error) in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            print(String(describing: result!))
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print(itemTitle)
            if allSavedAuctionIDs.contains(id) {
                SPAlert.present(title: "Already Added to Saved Auctions", preset: .error)
            } else {
                createNewSavedAuction(title: itemTitle, id: id)
                SPAlert.present(title: "Added to Saved Auctions", preset: .done)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("done")
        checkBackForwardButtons()
        // fill data
//        let savedUsername = "USERNAME"
//        let savedPassword = "PASSWORD"
//
//
//
//        webView.evaluateJavaScript("document.getElementById('txtUserName').value = '\(savedUsername)';", completionHandler: nil)
//        webView.evaluateJavaScript("document.getElementById('txtPassword').value = '\(savedPassword)';", completionHandler: nil)
//        webView.evaluateJavaScript("document.getElementById('rememberMe').ariaChecked = true;", completionHandler: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.webView.evaluateJavaScript("document.forms[\"submit\"].submit();", completionHandler: nil)
//        }
        
        //        //check checkboxes
        //        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('expert_remember_me').checked = true; document.getElementById('expert_terms_of_service').checked = true;")
        //
        //         //submit form
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()){
        //            webView.stringByEvaluatingJavaScriptFromString("document.forms[\"new_expert\"].submit();")
        //        }
        if "\(String(describing: webView.url))".contains("/item/") {
            print("ITEM LISTING")
            addToSavedButton.isHidden = false
        } else {
            addToSavedButton.isHidden = true
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.navigationController?.isNavigationBarHidden = !(self.splitViewController?.traitCollection.horizontalSizeClass == .compact)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            checkBackForwardButtons()
            if String(describing: key).contains("/item/") {
                print("ITEM LISTING")
                addToSavedButton.isHidden = false
            } else {
                addToSavedButton.isHidden = true
            }
        }
    }
    
}
