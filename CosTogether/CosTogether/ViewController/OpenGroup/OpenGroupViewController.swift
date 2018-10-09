//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/5.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import FSPagerView

class OpenGroupViewController: UIViewController {

    @IBOutlet weak var newProductBot: UIButton!
    @IBOutlet weak var inCollectionViewLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberOfProductCategoryLbl: UILabel!
    @IBOutlet weak var bottomConstriant: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var products: [ProductModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkoutProductNumber()

    }
    
    private func setup() {
        
        newProductBotSetup()
        setColletionView()
        navigationBarSetup()
       
    }
    
    private func navigationBarSetup() {
        
        let  image = UIImage()

        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = image
    }
    
    private func checkoutProductNumber() {
        
        guard products.count > 0 else {
            
            inCollectionViewLbl.isHidden = false
            
            collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
            collectionView.cornerSetup(
                cornerRadius: 4,
                borderWidth: 1,
                borderColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                maskToBounds: true
            )
            
            numberOfProductCategoryLbl.text = "\(self.products.count) 樣商品"

            return
        }
        
        inCollectionViewLbl.isHidden = true
        collectionView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView.cornerSetup(
            cornerRadius: 0,
            borderWidth: 0,
            borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            maskToBounds: true
        )

        numberOfProductCategoryLbl.text = "\(self.products.count) 樣商品"

    }
    
    private func setColletionView() {
        
        registerTableViewCell(identifier: String(describing: NewProductCollectionViewCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        layout.scrollDirection = .horizontal
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }

    private func newProductBotSetup() {
        
        newProductBot.cornerSetup(cornerRadius: 4, borderWidth: 2, borderColor: #colorLiteral(red: 0.1411764706, green: 0.3215686275, blue: 0.6196078431, alpha: 1), maskToBounds: true)
    }
    
    @IBAction func newProductBotTapping(_ sender: UIButton) {
        
        guard let controller = goToAppendProduct() as? AppendNewItemViewController else {
            
            return
        }
        
        controller.appendProduct { (product) in
            
            #warning ("要把 update image 上傳至 firebase ")
            self.products.append(product)
            BaseNotificationBanner.sucessBanner(subtitle: "商品新增成功")

            self.collectionView.reloadData()
            self.checkoutProductNumber()
            
        }
        
        show(controller, sender: nil)
    }
    
    private func goToAppendProduct() -> UIViewController? {
        
        guard let controller = UIStoryboard.appendProductItemStoryboard()
            .instantiateInitialViewController()
            as? AppendNewItemViewController else {
                
                return nil
        }
        
        return controller
    }

    @IBAction func uploadToServer(_ sender: UIButton) {
        
        //   let banner = NotificationBanner(title: "加團成功", subtitle: "詳細資訊請到歷史紀錄區查詢", style: .success) banner.show()
        
    }
    
    @IBAction func cityBotTapping(_ sender: UIButton) {
        
        bottomConstriant.constant = -200
        
    }
    
}

extension OpenGroupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        return products.count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: NewProductCollectionViewCell.self),
            for: indexPath
            ) as? NewProductCollectionViewCell else {
                
                print("No such cell")
                return UICollectionViewCell()
                
        }
        
        cell.newProductView.updateProductDetail(product: products[indexPath.row])
        
        return cell
    }
    
}

extension OpenGroupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width - 30
        
        let height = collectionView.frame.size.height - 30
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let controller = goToAppendProduct() as? AppendNewItemViewController else {
            
            return
        }
        
        controller.loadViewIfNeeded()
        
       let sheet = alertSheet(
            controller: controller,
            product: products[indexPath.row],
            indexPath: indexPath
        )
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    private func alertSheet(
        controller: AppendNewItemViewController,
        product: ProductModel,
        indexPath: IndexPath
        ) -> UIAlertController {
    
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "編輯商品", style: .default) { (_) in
            
            controller.editProductDetail(product: product)
            
            controller.appendProduct(product: { [weak self] (product) in
                
                self?.products[indexPath.row] = product
                
                BaseNotificationBanner.sucessBanner(
                    subtitle: "商品修改成功",
                    style: .info
                )
                
                self?.collectionView.reloadData()
            })
            
            self.show(controller, sender: nil)
        }

        let deleteAction = UIAlertAction(title: "刪除商品", style: .default) { (_) in

            self.products.remove(at: indexPath.row)
            self.collectionView.reloadData()
            
            BaseNotificationBanner.sucessBanner(
                subtitle: "商品刪除成功",
                style: .info
            )

            self.checkoutProductNumber()

        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        return alertController
    }

}
