//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class OpenGroupRootViewController: UIViewController {

    @IBOutlet weak var groupTypeSC: UISegmentedControl!
    @IBOutlet weak var shareBuyView: UIView!
    @IBOutlet weak var helpBuyView: UIView!
    @IBOutlet weak var topView: TopLogoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTypeSC.addUnderlineForSelectedSegment()
        
        self.navigationController?.navigationBar.isHidden = true
        
        shareBuyView.isHidden = false
        helpBuyView.isHidden = true
        
        setup()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        return .lightContent
    }
    
    private func setup() {
        
        navigationBarSetup()
    }
    
    @IBAction func switchGroupType(_ sender: Any) {
        
        groupTypeSC.changeUnderlinePosition()
        
        switch groupTypeSC.selectedSegmentIndex {
            
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

    private func navigationBarSetup() {
        
        let  image = UIImage()
        
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = image
    }
    
}
