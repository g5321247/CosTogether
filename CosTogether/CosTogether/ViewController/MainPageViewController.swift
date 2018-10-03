//
//  MainPageViewController.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var topView: TopLogoView!
    
    @IBOutlet weak var productTypeSC: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTypeSC.addUnderlineForSelectedSegment()
        topView.rightBot.addTarget(self, action: #selector (mapBotTappiung(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func switchProductType(_ sender: Any) {
        
        productTypeSC.changeUnderlinePosition()
        
    }
    
    #warning ("點擊地圖時")
    @objc func mapBotTappiung(_ sender: UIButton) {
        
    }
    
}
