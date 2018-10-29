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
        
        imagePicker.delegate = self
    
        tableViewSetup()
        setUpCell()
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
              String(describing: ImageTableViewCell.self),
            String(describing: ProductInfoTableViewCell.self),
            String(describing: ButtonTableViewCell.self)
            ])
    }

    private func pictureIsExsist() {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self)) as? ImageTableViewCell else {
            
            return
            
        }
        
        cell.picIconImage.isHidden = true
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
            
            return 212
            
        case 1:
            
            return 270

        case 2:
            
            return 80
            
        default:
            return 0
        }
    }

}

extension AppendNewItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonTableViewCell.self)) as? ButtonTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            
            return  cell
            
        default:
            
            return UITableViewCell()
            
        }
        
    }

    
}

extension AppendNewItemViewController: ProductSettingDelegate {
    
    func getProductName(name: String?) {
        
        productName = name
    }
    
    func getProductPrice(price: Int?) {
        
        productPrice = price
    }
    
    func getProductNumber(number: Int?) {
        
        numberOfProduct = number
        
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
        
        guard  let cell = cell else {
            return
        }
        
        cell.updateProductImage(image: tempImage)

        dismiss(animated: true, completion: nil)
    }
    
}

extension AppendNewItemViewController {
    
    @objc func choseProductImage(_ sender: UIButton) {
        
        alertSheet()
        
    }
    
    private func alertSheet() {
        
        let alertController = UIAlertController.showActionSheet(
        defaultOption: ["拍照","從照片庫選取"],
        images: [#imageLiteral(resourceName: "camera"), #imageLiteral(resourceName: "picture")]) { (action) in
            
            switch action.title {
                
            case "拍照":
            
                self.imagePicker.sourceType = .camera
                self.imagePicker.modalPresentationStyle = .fullScreen
                
                action.setValue(#imageLiteral(resourceName: "camera"), forKey: "image")
                
                self.present(self.imagePicker, animated: true, completion: nil)

            case "從照片庫選取":
                
                self.imagePicker.sourceType = .photoLibrary
                
                self.present(self.imagePicker, animated: true, completion: nil)
            
            default:
                
                break
            }
            
        }
        
        self.present(alertController, animated: true,completion: nil)

    }
    
}
