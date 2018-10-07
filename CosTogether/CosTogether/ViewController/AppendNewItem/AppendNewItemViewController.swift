//
//  AppendNewItemViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class AppendNewItemViewController: UIViewController {

    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var prodctSettingView: ProductSettingView!
    @IBOutlet weak var newProductPicBot: UIButton!
    @IBOutlet weak var remindChosePicLbl: UILabel!
    
    var productQuantity: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        navigationController?.navigationBar.isHidden = true
        leftButtonSetup()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottnSetup()

    }
    
    private func bottnSetup() {
        
        newProductPicBot.addDashdeBorderLayer(color: #colorLiteral(red: 0.1411764706, green: 0.3215686275, blue: 0.6196078431, alpha: 1), lineWidth: 3)
        
        prodctSettingView.decreaseNumBot.addTarget(self, action: #selector (quantityBotTapping(_:)), for: .touchUpInside)
        prodctSettingView.increaseNumBot.addTarget(self, action: #selector ((quantityBotTapping(_:))), for: .touchUpInside)

    }
    
    private func leftButtonSetup() {
        
        topView.leftBot.addTarget(self, action: #selector (backToController(_:)), for: .touchUpInside)
        
    }

    @objc func backToController(_ sneder: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
 
    @IBAction func chosePicBotTapping(_ sender: UIButton) {
        show(alertSheet(), sender: nil)
    }
    
    private func alertSheet() -> UIAlertController {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (_) in
            
        }
        
        let chosePicAction = UIAlertAction(title: "從照片庫選取", style: .default) { (_) in
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cameraAction.setValue(#imageLiteral(resourceName: "camera"), forKey: "image")
        chosePicAction.setValue(#imageLiteral(resourceName: "picture"), forKey: "image")
        
        alertController.addAction(cameraAction)
        alertController.addAction(chosePicAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    @objc func quantityBotTapping(_ sender: UIButton) {
        
        if sender == prodctSettingView.increaseNumBot {
            
            guard productQuantity < 99 else {
                
                return
            }
            
            productQuantity += 1
            
            prodctSettingView.productQuantityLbl.text = "\(productQuantity)"
            
        } else if sender == prodctSettingView.decreaseNumBot {
            
            guard productQuantity > 0 else {
                
                return
            }
            
            productQuantity -= 1
            
            prodctSettingView.productQuantityLbl.text = "\(productQuantity)"

        }
        
    }
    
}
