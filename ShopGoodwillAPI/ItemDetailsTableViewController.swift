//
//  ItemDetailsTableViewController.swift
//  ShopGoodwillAPI
//
//  Created by Dylan McDonald on 1/9/22.
//

import UIKit

class ItemDetailsTableViewController: UITableViewController {

    var itemID: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bidsLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
