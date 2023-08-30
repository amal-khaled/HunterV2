//
//  AddStoreVC.swift
//  Hunter
//
//  Created by iOSayed on 28/08/2023.
//

import UIKit

class CreateStoreVC: UIViewController {
    
    static func instantiate()-> CreateStoreVC{
        let addStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "AddStoreVC") as! CreateStoreVC
        
        return addStoreVC
    }
    
    
    // MARK: - IBOutlets
    
    
    
    // MARK: - Properties
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    
    // MARK: - Methods
    
    private func configureView(){
        self.title = "Add Store".localize
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
    // MARK: - IBActions

   

}
