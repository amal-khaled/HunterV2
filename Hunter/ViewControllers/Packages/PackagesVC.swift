//
//  PackagesVC.swift
//  Hunter
//
//  Created by iOSayed on 03/09/2023.
//

import UIKit

class PackagesVC: UIViewController {
    
    static func instantiate() -> PackagesVC {
        
        let controller = UIStoryboard(name: "Packages", bundle: nil).instantiateViewController(withIdentifier: "PackagesVC") as! PackagesVC
        
        return controller
    }

    //MARK: IBOulets
    
    @IBOutlet weak var silverButton: UIButton!
    @IBOutlet weak var goldButton: UIButton!
    @IBOutlet weak var diamondButton: UIButton!
    @IBOutlet weak var bestSellerFlag: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
//        bestSellerFlag.shake()
        setupButton(for: silverButton, isTapped: true)
        setupButton(for: goldButton, isTapped: false)
        setupButton(for: diamondButton, isTapped: false)
    }
    
    
  private func setupButton(for button: UIButton, isTapped:Bool){
        if isTapped {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(named: "#0093F5")
        }else {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        }
        
    }
    
    
    
    
    
    
  
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSilverButton(_ sender: UIButton) {
        setupButton(for: silverButton, isTapped: true)
        setupButton(for: goldButton, isTapped: false)
        setupButton(for: diamondButton, isTapped: false)
    }
    
    @IBAction func didTapGoldButton(_ sender: UIButton) {
        setupButton(for: silverButton, isTapped: false)
        setupButton(for: goldButton, isTapped: true)
        setupButton(for: diamondButton, isTapped: false)
    }
    
    @IBAction func didTapDiamondButton(_ sender: UIButton) {
        setupButton(for: silverButton, isTapped: false)
        setupButton(for: goldButton, isTapped: false)
        setupButton(for: diamondButton, isTapped: true)
    }
    
    
}
