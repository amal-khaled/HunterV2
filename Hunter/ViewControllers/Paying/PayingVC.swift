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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load a URL
             if let url = URL(string: "https://example.com") {
                 let request = URLRequest(url: url)
                 webView.load(request)
             }
         
    }
    

    // MARK: - Navigation
    @IBAction func didTapBackButton(_ sender: UIButton) {
    }
    
    

}
