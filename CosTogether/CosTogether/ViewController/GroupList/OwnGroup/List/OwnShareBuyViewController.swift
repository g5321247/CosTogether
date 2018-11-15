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

class OwnShareBuyViewController: BaseHistoryViewController, OwnGroupDownloading {
    
    override func viewDidLoad() {
        
        groupType = .shareBuy
        myGroup = .own
        
        downloadGroupList()
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            firebaseManager.deleteValue(group: myGroups[indexPath.row].group!)
            
            myGroups.remove(at: indexPath.row)
            
            NotificationCenter.default.post(name: .createNewGroup, object: nil, userInfo: nil)
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
    }
}
