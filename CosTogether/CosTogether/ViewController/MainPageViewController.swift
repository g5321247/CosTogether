//
//  MainPageViewController.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit
import  Firebase

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var productTypeSC: UISegmentedControl!
    
    @IBOutlet weak var shareBuyView: UIView!
    @IBOutlet weak var helpBuyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareBuyView.isHidden = false
        helpBuyView.isHidden = true

        productTypeSC.addUnderlineForSelectedSegment()
        topView.rightBot.addTarget(self, action: #selector (mapBotTappiung(_:)), for: .touchUpInside)
        
        Analytics.logEvent("StayMainPage", parameters: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func switchProductType(_ sender: Any) {
        
        productTypeSC.changeUnderlinePosition()
        
        switch productTypeSC.selectedSegmentIndex {
            
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
    
    #warning ("點擊地圖時")
    @objc func mapBotTappiung(_ sender: UIButton) {
        
    }
    
}
