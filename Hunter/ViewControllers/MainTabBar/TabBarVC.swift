//
//  TabBarVCViewController.swift
//  Hunter
//
//  Created by iOSayed on 11/09/2023.
//

import UIKit
import WoofTabBarController

class TabBarVC: WoofTabBarController {

    static let shared = TabBarVC()
    override var defaultIndex: Int { 0 }
    
    let homeVC = HomeNavigationController.instantiate()
    let storesVC = StoreNavigationController.instantiate()
    let addAdsVC = AddAddNavigationController.instantiate()
    let categoryVC = CategoryNavigationController.instantiate()
    let menuVC = ProfileNavigationController.instantiate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
        self.configureTabBarView { (barview) in
            barview.shadow = (3.0, 0.5, .zero, .gray)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchToTab(_:)), name: NSNotification.Name("SwitchToTab"), object: nil)

       
        
    }
    
    @objc func switchToTab(_ notification: Notification){
            // Get the desired tab index from the notification
            if let _ = notification.object as? Int {
                // Switch to the specified tab index
                
                let menuVC = menuVC
//                delegate?.didDeSelectItem(itemView: currentItemView, vc: menuVC, atIndex: 4)
                replaceTabVC(withTabVCAt: 2)
                self.currentTabVC = addAdsVC
                self.currentItemView = tabBarView.itemView(at: 2)
////                currentItemView = tabBarView.itemView(at: 2)
//                let addAdsVC = addAdsVC
//                currentItemView = tabBarView.itemView(at: 4)
//                delegate?.didDeSelectItem(itemView: currentItemView, vc: menuVC, atIndex: 4)
//                delegate?.didSelectItem(itemView: currentItemView, destinationVC: addAdsVC, atIndex: 2)
//                delegate?.didAnimateItem(itemView: currentItemView, destinationVC: addAdsVC, atIndex: 2)
//                if ((delegate?.shouldAnimateItem(itemView: currentItemView, destinationVC: addAdsVC, atIndex: 2)) != nil) {
//                   return  addAdsVC.shouldAnimate()
//                }
//
//                if ((delegate?.shouldHighlightItem(itemView: currentItemView, destinationVC: addAdsVC, atIndex: 2)) != nil) {
//                    return addAdsVC.shouldHighlight()
//                }
//
            }
        }

    override func viewControllers() -> [WoofTabControllerItem] {
        return [homeVC,storesVC,addAdsVC,categoryVC,menuVC]
                //, storesVC, addAdsVC, categoryVC, menuVC]
    }
    
}

extension TabBarVC: WoofTabBarControllerBarViewDelegate {
    func shouldSelectItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {
        navigationController?.popToRootViewController(animated: false)
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
