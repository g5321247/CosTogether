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
    @IBOutlet weak var shareGroupView: UIView!
    @IBOutlet weak var helpGroupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTypeSC.addUnderlineForSelectedSegment()

        shareGroupView.isHidden = false
        helpGroupView.isHidden = true
        
        navigationController?.navigationBar.isHidden = true

    }
    
    @IBAction func switchGroupType(_ sender: Any) {
        
        groupTypeSC.changeUnderlinePosition()
        
        switch groupTypeSC.selectedSegmentIndex {
            
        case 0:
            
            shareGroupView.isHidden = false
            
            helpGroupView.isHidden = true
            
        case 1:
            
            shareGroupView.isHidden = true
            helpGroupView.isHidden = false
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "helpBuy":
            
            guard let helpGroupController = segue.destination as?BaseHistoryViewController else {
                
                return
                
            }
            
            helpGroupController.loadViewIfNeeded()
            
            helpGroupController.downloadGroupList(groupType: .shareBuy, myGroup: .join)
            
        case "shareBuy":

            guard let shareGroupController = segue.destination as?BaseHistoryViewController else {
                
                return
                
            }
            
            shareGroupController.loadViewIfNeeded()
            
            shareGroupController.downloadGroupList(groupType: .helpBuy, myGroup: .join)
            
        default:
            return
        }
        
    }
    
}
