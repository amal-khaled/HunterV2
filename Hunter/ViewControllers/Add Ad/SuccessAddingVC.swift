//
//  SuccessAddingVC.swift
//  Hunter
//
//  Created by iOSayed on 01/05/2023.
//

import UIKit

class SuccessAddingVC: UIViewController {
    var isFromHome = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isHidden = false

        
    }
    //MARK:  IBActions
    
    @IBAction func didTapuploadNewAds(_ sender: UIButton) {
        //TODO:   handle this case going to AddAdsVC on tapBar
        dismiss(animated: false)
    }
    @IBAction func didTapGoToMyAds(_ sender: UIButton) {

        
        if let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: MYADS_VCID) as? MyAdsVC {
            print("ViewController instantiated successfully.")
            
            vc.modalPresentationStyle = .fullScreen
            if let currentUserID = AppDelegate.currentUser.id {
                print("User ID found: \(currentUserID)")
                vc.userId = currentUserID
            } else {
                print("User ID is nil or 0.")
            }
            
            if let navigationController = navigationController {
                navigationController.pushViewController(vc, animated: true)
                print("Pushing view controller.")
            } else {
                print("Navigation controller is nil.")
            }
        } else {
            print("Failed to instantiate ViewController.")
        }
        
    }
}
