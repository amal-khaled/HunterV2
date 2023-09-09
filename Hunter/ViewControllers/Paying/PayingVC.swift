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
        
        webView.navigationDelegate = self
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
extension PayingVC :WKNavigationDelegate {
    // MARK: - WKNavigationDelegate
       
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        print("Navigating to: \(navigationAction.request.url?.absoluteString ?? "Unknown URL")")
      // Check if the current URL is the "Cancel" URL
        
        if let url =  navigationAction.request.url,
           url.absoluteString.contains("PaymentID")  {
               // Parse the URL to get the paymentId
               let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
               let paymentId = components?.queryItems?.first(where: { $0.name == "PaymentID" })?.value
               
               print("Payment ID: \(paymentId ?? "Unknown")")
               // Cancel the navigation
               decisionHandler(.allow)
               return
           }
        
      if let url = navigationAction.request.url,
         url.absoluteString.contains("callback") {
        
        // Pop the view controller
        navigationController?.popViewController(animated: true)

        // Cancel the navigation
        decisionHandler(.cancel)
        return
      }
      
      // Allow the navigation
      decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementById('paymentId').value") { (result, error) in
            if let error = error {
                print("JavaScript evaluation error: \(error)")
            } else if let paymentId = result as? String {
                print("Got paymentId: \(paymentId)")
                // Now you can use the paymentId
            }
        }
    }
   
}
