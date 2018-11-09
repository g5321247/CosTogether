//
//  MainPageViewController.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit
import Firebase

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var shareBuyView: UIView!
    @IBOutlet weak var helpBuyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareBuyView.isHidden = false
        helpBuyView.isHidden = true

        segmentedControl.addUnderlineForSelectedSegment()
        
        Analytics.logEvent("StayMainPage", parameters: nil)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func switchProductType(_ sender: Any) {
        
        segmentedControl.changeUnderlinePosition()
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            
            shareBuyView.isHidden = false
            helpBuyView.isHidden = true
            
        case 1:
            
            shareBuyView.isHidden = true
            helpBuyView.isHidden = false
            
        default:
            break
        }

    }
        
}
