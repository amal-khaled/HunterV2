//
//  PayingVC.swift
//  Hunter
//
//  Created by iOSayed on 07/09/2023.
//

import UIKit
import WebKit

class PayingVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var paymentId = 0
    var urlString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load a URL
             if let url = URL(string: urlString) {
                 let request = URLRequest(url: url)
                 webView.load(request)
                 
             }
         
    }
    

    // MARK: - Navigation
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    

}
