//
//  MyGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import SDWebImage

class JoinHelpGroupViewController: BaseHistoryViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupType = .helpBuy
        myGroup = .join
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
