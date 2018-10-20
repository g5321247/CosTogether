//
//  AgreementViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import WebKit

class AgreementViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    private func setup() {
        
        webViewSetup()
        
    }
    
    private func webViewSetup() {
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    @IBAction func goToEULAWeb(_ sender: UIButton) {
        
        guard let url = URL(string: "https://termsfeed.com/eula/ae69cb87067ad072279365009dece100") else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }

    @IBAction func  goToTermOfServiceWeb(_ sender: UIButton) {
        
        
    }
    
    @IBAction func goToPrivicyWeb(_ sender: UIButton) {
        
        
    }


}

extension AgreementViewController: WKUIDelegate, WKNavigationDelegate {
    
    
    
    
}
