//
//  HomeNavigationController.swift
//  Hunter
//
//  Created by Amal Elgalant on 12/09/2023.
//

import UIKit
import WoofTabBarController

class HomeNavigationController: UINavigationController {
    
    static func instantiate()->HomeNavigationController{
        let controller = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"homeT") as! HomeNavigationController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeNavigationController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
    
    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Home".localize, image: "home", selectedImage: "HomeButtonIcon",notificationCount: 3)
    }
}
