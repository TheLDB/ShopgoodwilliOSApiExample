
//
//  AboutTableViewController.swift
//  School Assistant
//
//  Created by Dylan McDonald on 6/14/20.
//  Copyright © 2020 Dylan McDonald. All rights reserved.
//

import UIKit

import SafariServices

class AboutTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = true
            self.splitViewController?.primaryBackgroundStyle = .sidebar
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
            headerView.backgroundColor = .clear
            self.tableView.tableHeaderView = headerView
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
        tableView.tintColor = UIColor(named: "AccentColor")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 2 {
            let urlString = "https://sunapps.org"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = UIColor(named: "AccentColor")!
                vc.view.tintColor = UIColor(named: "AccentColor")!
                vc.delegate = self
                present(vc, animated: true)
            }
        }
        
        if indexPath.section == 4 {
            
            let urlString = "https://sunapps.org/privacypolicy"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = UIColor(named: "AccentColor")!
                vc.view.tintColor = UIColor(named: "AccentColor")!
                vc.delegate = self
                present(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
