//
//  DetailViewController.swift
//  
//
//  Created by George Liu on 2018/9/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var messageView: MessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setInputMessage() {
        
        messageView.sendMessageBot.addTarget(self, action: #selector (sendMessage), for: .touchUpInside)
        
    }

    @objc func sendMessage() {
        
        print("yes")
        
    }
}
