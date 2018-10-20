//
//  AgreementViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import NotificationBannerSwift

class AgreementViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    private func setup() {
        
        webViewSetup()
        startingPage()
    }
    
    private func webViewSetup() {
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    private func startingPage() {
        
        SVProgressHUD.show()
        
        guard let url = URL(string: "https://termsfeed.com/eula/ae69cb87067ad072279365009dece100") else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)

    }
    
    @IBAction func goToEULAWeb(_ sender: UIButton) {
        
        SVProgressHUD.show()

        guard let url = URL(string: "https://termsfeed.com/eula/ae69cb87067ad072279365009dece100") else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }
    
    @IBAction func goToPrivicyWeb(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        guard let url = URL(string: "https://privacypolicies.com/privacy/view/71d86619bed81edc83c6c67895823dd2") else {
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }
    
    
    @IBAction func backToLoginPage(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
}

extension AgreementViewController: WKUIDelegate, WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        BaseNotificationBanner.warningBanner(subtitle: "連線失敗，請確認網路連線狀況")
        
        SVProgressHUD.dismiss()
    }
    
}
