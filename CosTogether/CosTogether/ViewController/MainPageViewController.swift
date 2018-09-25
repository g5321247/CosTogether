//
//  MainPageViewController.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var searchThingBar: UISearchBar!
    
    @IBOutlet weak var locationBot: UIButton!
    @IBOutlet weak var productTypeSC: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchThingBar.setSearchBar()
        locationBot.setCornerRadius(color: UIColor.gray)
        productTypeSC.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func switchProductType(_ sender: Any) {
        
        productTypeSC.changeUnderlinePosition()
        
    }
    
}
