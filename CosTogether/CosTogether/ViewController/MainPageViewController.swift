//
//  MainPageViewController.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var locationBot: UIButton!
    @IBOutlet weak var productTypeSC: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationBot.cornerSetup(cornerRadius: 5,
                                borderWidth: 1,
                                borderColor: UIColor.lightGray.cgColor
        )
        
        productTypeSC.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func switchProductType(_ sender: Any) {
        
        productTypeSC.changeUnderlinePosition()
        
    }
    
}
