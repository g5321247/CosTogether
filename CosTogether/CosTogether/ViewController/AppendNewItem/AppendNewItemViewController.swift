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
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var prodctSettingView: ProductSettingView!
    @IBOutlet weak var newProductPicBot: UIButton!
    @IBOutlet weak var remindChosePicLbl: UILabel!
    @IBOutlet weak var appendProductBot: UIButton!
    
    var productName: String?
    var productPrice: Int?
    var numberOfProduct: Int?
    
    let imagePicker = UIImagePickerController()
    
    var cell : ImageTableViewCell?
    
    var product: ProductModel?
    var passProductInfo: ((ProductModel) -> Void)?
    var productImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    
    private func setup() {
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
//        prodctSettingView.delegate = self
        imagePicker.delegate = self
    
        tableViewSetup()
        setUpCell()
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
    }
    
    #warning ("搬到 cell 去")
    private func bottnSetup() {
        
        appendProductBot.cornerSetup(cornerRadius: 2.5)
        appendProductBot.shadowSetup()
        
        appendProductBot.imageView?.contentMode = .scaleAspectFill
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: ImageTableViewCell.self),
            String(describing: ProductInfoTableViewCell.self)
            ])
    }

    private func pictureIsExsist() {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self)) as? ImageTableViewCell else {
            
            return
            
        }
        
        cell.picIconImage.isHidden = true
    }
    
    @objc func choseProductImage(_ sender: UIButton) {
        
        self.present(
            alertSheet(),
            animated: true,
            completion: nil
        )
        
    }

    func editProductDetail(product: ProductModel) {
        
        pictureIsExsist()
        
//        prodctSettingView.updateProductDetail(product: product)
        
        newProductPicBot.setImage(product.updateImage, for: .normal)
    }
    
    @IBAction func appendNewProduct(_ sender: UIButton) {
        
//        prodctSettingView.updateProductInfo()
        
        guard let product = product,
        product.updateImage != nil,
        let passProductInfo = passProductInfo else {
            
            return
        }
        
        passProductInfo(product)
        
        CosNavigationControllerViewController.isLightStatusBar = true
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func appendProduct(product: @escaping (ProductModel) -> Void) {
        
        passProductInfo = product
        
    }
    
    @IBAction func backBotTapping(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AppendNewItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0:
            
            return self.view.frame.width * (165 / 375)
            
        case 1:
            
            return self.view.frame.width * (200 / 375)
            
        default:
            return 0
        }
    }

}

extension AppendNewItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self)) as? ImageTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            self.cell = cell
            
            cell.productImageBot.addTarget(self, action: #selector (choseProductImage(_:)), for: .touchUpInside)
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductInfoTableViewCell.self)) as? ProductInfoTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.delegate = self
            
            return  cell
            
            
        default:
            
            return UITableViewCell()
            
        }
        
    }

    
}

extension AppendNewItemViewController: ProductSettingDelegate {
    
    func getProductSetting(name: String?, price: String?, number: String?) {
        print(name)
        print(price)
        print(number)
    }
    
    
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
        
        guard  let cell = cell as? ImageTableViewCell else {
            return
        }
        
        cell.updateProductImage(image: tempImage)
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension AppendNewItemViewController {
    
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
    
}
