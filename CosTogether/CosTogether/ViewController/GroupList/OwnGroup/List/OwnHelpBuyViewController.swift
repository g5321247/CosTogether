//
//  MyGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Lottie
import SDWebImage

class OwnHelpBuyViewController: BaseHistoryViewController, OwnGroupDownloading {
    
    override func viewDidLoad() {
        
        groupType = .helpBuy
        myGroup = .own
        
        downloadGroupList()
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
}
