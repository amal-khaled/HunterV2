//
//  TabBarVCViewController.swift
//  Hunter
//
//  Created by iOSayed on 11/09/2023.
//

import UIKit
import WoofTabBarController

class TabBarVC: WoofTabBarController {

    override var defaultIndex: Int { 0 }
    
    let homeVC = HomeViewController.instantiate()
    let storesVC = StoresVC.instantiate()
    let addAdsVC = AddAdvsVC.instantiate()
    let categoryVC = CategoryViewController.instantiate()
    let menuVC = MenuVC.instantiate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
        self.configureTabBarView { (barview) in
            barview.shadow = (3.0, 0.5, .zero, .gray)
        }
        
        
    }

    override func viewControllers() -> [WoofTabControllerItem] {
        return [homeVC, storesVC, addAdsVC, categoryVC, menuVC]
    }
}

extension TabBarVC: WoofTabBarControllerBarViewDelegate {
    func shouldSelectItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {

        return true
    }
    
    func shouldHighlightItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {
        true
    }
    
    func shouldAnimateItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {
        true
    }
    
    func didSelectItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) {
        print("Selected \(atIndex)")
    }
    
    func didDeSelectItem(itemView: WoofTabBarItemView, vc: WoofTabBarController.WoofTabControllerItem, atIndex: Int) {
        print("De-Selected \(atIndex)")
    }
    
    func didAnimateItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) {
        print("Ainmated \(atIndex)")
    }
}
