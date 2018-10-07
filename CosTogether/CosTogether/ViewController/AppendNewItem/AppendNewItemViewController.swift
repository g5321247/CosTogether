//
//  AppendNewItemViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class AppendNewItemViewController: UIViewController {

    @IBOutlet weak var topView: TopLogoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        navigationController?.navigationBar.isHidden = true
        leftButtonSetup()
    }
    
    private func leftButtonSetup() {
        
        topView.leftBot.addTarget(self, action: #selector (backToController(_:)), for: .touchUpInside)
        
    }

    @objc func backToController(_ sneder: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
