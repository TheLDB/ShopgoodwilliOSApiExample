//
//  SavedAuctionsTableViewController.swift
//  ShopGoodwill
//
//  Created by Dylan McDonald on 1/2/22.
//

import UIKit

class SavedAuctionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = true
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
            headerView.backgroundColor = .clear
            self.tableView.tableHeaderView = headerView
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSavedAuctions()
        self.tableView.reloadData()
        #if targetEnvironment(macCatalyst)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            updateTitlebarTitle(with: "Saved Auctions", session: (self.view.window?.windowScene?.session)!)
        }
        #endif
    }

    @objc func goBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SavedItemDetails") as! SavedItemDetailsTableViewController
        let navView = UINavigationController(rootViewController: detailView)
        navView.navigationBar.prefersLargeTitles = true
        navView.navigationItem.largeTitleDisplayMode = .always
        detailView.myIndex = indexPath.section
        
        self.show(detailView, sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if savedAuctions.count > 0 {
            return savedAuctions.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAllDataForSavedAuction(forIndex: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .left)
            self.tableView.endEditing(true)
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if savedAuctions.count > 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
            cell.textLabel?.text = SavedAuctionsTitle(forIndex: indexPath.section)
            cell.detailTextLabel?.text = SavedAuctionsID(forIndex: indexPath.section)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "noAuctions", for: indexPath)
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt selectedIndexPath: IndexPath)
    ->   UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
            self.deleteSavedItem(forIndex: selectedIndexPath.section)
            self.tableView.deleteSections([selectedIndexPath.section], with: .left)
        })
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    func deleteSavedItem(forIndex: Int) {
        self.view.endEditing(true)
        deleteAllDataForSavedAuction(forIndex: forIndex)
//        if forIndex < self.mainScheduleData.count - 1 {
//            for indexToUse in forIndex...self.mainScheduleData.count - 1 {
//                self.SaveScheduleSortIndex(with: Int16(indexToUse - 1), forIndex: indexToUse)
//            }
//        }
        self.tableView.deleteSections([forIndex], with: .right)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(indexPath: indexPath)
        })
    }
    
    var deleteName: String = "Delete"
    private func makeContextMenu(indexPath: IndexPath) -> UIMenu {
        if runningOn == "Mac" {
            deleteName = "􀈑  Delete"
        }
        
        let delete = UIAction(title: deleteName, image: UIImage(systemName: "trash")) { action in
            self.deleteSavedItem(forIndex: indexPath.section)
        }
        
        return UIMenu(title: "More Actions", children: [delete])
    }
    
}
