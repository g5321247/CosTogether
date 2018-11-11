//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class OwnGroupRootViewController: UIViewController {

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
    
    @IBAction func createNewGroup(_ sender: UIButton) {
        
        guard UserManager.shared.userInfo() != nil else {
            
            BaseNotificationBanner.warningBanner(subtitle: "匿名使用者無法開團，請用 FB 登入")

            return
        }

        switch groupTypeSC.selectedSegmentIndex {
            
        case 0:
            
            guard let controller = UIStoryboard.appendProductItemStoryboard().instantiateInitialViewController() as?
                CreateGroupViewController else {
                    return
            }
            
            controller.loadViewIfNeeded()
            
            controller.topTitleLbl.text = "開分購"
            
            show(controller, sender: nil)
            
        case 1:
            
            guard let controller = UIStoryboard.appendProductItemStoryboard().instantiateInitialViewController() as?
                CreateGroupViewController else {
                    return
            }
            
            controller.loadViewIfNeeded()

            controller.topTitleLbl.text = "幫代購"
            
            controller.openGroupType = .helpBuy
            
            show(controller, sender: nil)

        default:
            break
        }
        
    }
}
