//
//  BasicView.swift
//  ShopGoodwill
//
//  Created by Dylan McDonald on 1/2/22.
//

import UIKit

class BasicView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        if runningOn == "Mac" {
            self.navigationController?.isNavigationBarHidden = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        #if targetEnvironment(macCatalyst)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            updateTitlebarTitle(with: "Saved Auctions", session: (self.view.window?.windowScene?.session)!)
//        }
//        #endif
    }
    
    @objc func goBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }

  

}
