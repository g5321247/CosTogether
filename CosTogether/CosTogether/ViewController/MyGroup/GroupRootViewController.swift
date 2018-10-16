//
//  GroupRootViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class GroupRootViewController: UIViewController {
    
    @IBOutlet weak var groupTypeSC: UISegmentedControl!
    @IBOutlet weak var joinGroupView: UIView!
    @IBOutlet weak var ownGroupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTypeSC.addUnderlineForSelectedSegment()

        joinGroupView.isHidden = false
        ownGroupView.isHidden = true
        
        navigationController?.navigationBar.isHidden = true

    }
    
    @IBAction func switchGroupType(_ sender: Any) {
        
        groupTypeSC.changeUnderlinePosition()
        
        switch groupTypeSC.selectedSegmentIndex {
            
        case 0:
            
            joinGroupView.isHidden = false
            ownGroupView.isHidden = true
            
        case 1:
            
            joinGroupView.isHidden = true
            ownGroupView.isHidden = false
            
        default:
            break
        }

        
    }

    
}
