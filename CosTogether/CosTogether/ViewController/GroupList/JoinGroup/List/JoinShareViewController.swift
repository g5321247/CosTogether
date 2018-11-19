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

class JoinShareViewController: BaseHistoryViewController, OwnGroupDownloading {
    
    override func viewDidLoad() {
        
        groupType = .shareBuy
        myGroup = .join
        
        downloadGroupList()
        
        super.viewDidLoad()
        
    }
        
}
