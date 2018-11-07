//
//  BaseOwnHistoryViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/11/8.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Firebase

class BaseOwnHistoryViewController: BaseHistoryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func downloadGroupList() {
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            return
        }
        
        firebaseManager.downloadMyOwnGroup(groupType: groupType, myGroup: myGroup) { (group) in
            
            self.firebaseManager.getGroupInfo(ownGroup: group, completion: { (group) in
                
                self.myGroups.append(group)
                
                self.emptyLbl.isHidden = true
                self.animationView.isHidden = true
                
                self.emptyViewIsHidden(isHidden: true)
                
                self.reloadData()
                
            })
        }
    }
}
