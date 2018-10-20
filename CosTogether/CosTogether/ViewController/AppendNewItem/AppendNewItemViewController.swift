//
//  AppendNewItemViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import AVFoundation
import NotificationBannerSwift

class AppendNewItemViewController: UIViewController {

    @IBOutlet weak var prodctSettingView: ProductSettingView!
    @IBOutlet weak var newProductPicBot: UIButton!
    @IBOutlet weak var remindChosePicLbl: UILabel!
    @IBOutlet weak var appendProductBot: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var product: ProductModel?
    var passProductInfo: ((ProductModel) -> Void)?
    var productImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        

    }
    
    private func setup() {
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        prodctSettingView.delegate = self
        imagePicker.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottnSetup()

    }
    
    private func bottnSetup() {
        
        newProductPicBot.addDashdeBorderLayer(color: #colorLiteral(red: 0.7126446366, green: 0.731051445, blue: 0.764359653, alpha: 1), lineWidth: 3)
        appendProductBot.cornerSetup(cornerRadius: 2.5)
        appendProductBot.shadowSetup()
        
        appendProductBot.imageView?.contentMode = .scaleAspectFill
    }
    
    private func pictureIsExsist() {
        
        newProductPicBot.cornerSetup(
            cornerRadius: 1,
            borderWidth: 4,
            borderColor: UIColor.white.cgColor,
            maskToBounds: true
        )
        
        remindChosePicLbl.isHidden = true
    }
    
    @IBAction func chosePicBotTapping(_ sender: UIButton) {
        
        self.present(
            alertSheet(),
            animated: true,
            completion: nil
        )

    }
    
    func editProductDetail(product: ProductModel) {
        
        pictureIsExsist()
        
        prodctSettingView.updateProductDetail(product: product)
        
        newProductPicBot.setImage(product.updateImage, for: .normal)
    }
    
    @IBAction func appendNewProduct(_ sender: UIButton) {
        
        prodctSettingView.updateProductInfo()
        
        guard let product = product,
        product.updateImage != nil,
        let passProductInfo = passProductInfo else {
            
            return
        }
        
        passProductInfo(product)
        
        CosNavigationControllerViewController.isLightStatusBar = true
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func alertSheet() -> UIAlertController {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (_) in
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let chosePicAction = UIAlertAction(title: "從照片庫選取", style: .default) { (_) in
            
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)

        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cameraAction.setValue(#imageLiteral(resourceName: "camera"), forKey: "image")
        chosePicAction.setValue(#imageLiteral(resourceName: "picture"), forKey: "image")
        
        alertController.addAction(cameraAction)
        alertController.addAction(chosePicAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func appendProduct(product: @escaping (ProductModel) -> Void) {
        
        passProductInfo = product
        
    }
    
}

extension AppendNewItemViewController: ProductSettingDelegate {
    
    func getProductSetting(product: ProductModel) {
        
        self.product = product
        
        guard let productImage = newProductPicBot.imageView?.image else {
            
            BaseNotificationBanner.warningBanner(subtitle: "請上傳商品照片")
            return
        }
        
        self.product!.updateImage = productImage
    }
    
}

extension AppendNewItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
        
        guard let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            BaseNotificationBanner.warningBanner(subtitle: "請上傳有效照片")

            return
        }
        
        pictureIsExsist()
        
        productImage = tempImage
        
        newProductPicBot.setImage(tempImage, for: .normal)
        newProductPicBot.imageView?.contentMode = .scaleAspectFill
        newProductPicBot.imageView?.cornerSetup(cornerRadius: 20)
        
        dismiss(animated: true, completion: nil)
    }
    
}
