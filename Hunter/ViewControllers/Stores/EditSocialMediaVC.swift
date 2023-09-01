//
//  EditSocialMediaVC.swift
//  Hunter
//
//  Created by iOSayed on 01/09/2023.
//

import UIKit

class EditSocialMediaVC: UIViewController {

    
    static func instantiate()-> EditSocialMediaVC{
        let addStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "EditSocialMediaVC") as! EditSocialMediaVC
        
        return addStoreVC
    }
    
    
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var insatgramTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func didTabCloseButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        
        
    }
    
}
