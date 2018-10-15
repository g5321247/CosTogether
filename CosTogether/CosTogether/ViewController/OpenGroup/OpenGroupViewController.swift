//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/5.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Firebase
import AnimatedCollectionViewLayout
import SVProgressHUD

class OpenGroupViewController: UIViewController {

    @IBOutlet weak var newProductBot: UIButton!
    @IBOutlet weak var inCollectionViewLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberOfProductCategoryLbl: UILabel!
    @IBOutlet weak var bottomConstriant: NSLayoutConstraint!
    @IBOutlet weak var pickerViewBackgroundView: UIView!
    @IBOutlet weak var createArticle: CreateArticleView!
    @IBOutlet weak var pickerView: PickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let dispatchGroup = DispatchGroup()
    
    var products: [ProductModel] = []
    
    var openGroupType: OpenGroupType = .shareBuy

    var city: String?
    
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkoutProductNumber()

    }
    
    private func setup() {
        
        setColletionView()
        navigationBarSetup()
        pickerViewBackgroundView.isHidden = true
        pickerView.delegate = self
        segmentedControl.addUnderlineForSelectedSegment()
        
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
                cornerRadius: 4 ,
                borderWidth: 1,
                borderColor: #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1),
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
        
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }
    
    @IBAction func newProductBotTapping(_ sender: UIButton) {
        
        guard let controller = goToAppendProduct() as? AppendNewItemViewController else {
            
            return
        }
        
        controller.appendProduct { (product) in
            
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

    func checkProductContent() -> Group? {
        
        guard let articleTitle = createArticle.titleTxf.text,
            articleTitle != "" else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入標題")
                
                return nil
        }
        
        guard let city = city else {
            
            BaseNotificationBanner.warningBanner(subtitle: "請選擇城市")
            
            return nil

        }
        
        guard let articleContent = createArticle.contentTextView.text,
            articleContent != "" else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入詳細資訊內容")
                
                return nil
        }
        
        guard products.count > 0 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "商品品項不得為零")
            
            return nil

        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            BaseNotificationBanner.warningBanner(subtitle: "匿名使用者無發文權利")
            
            return nil
        }
        
        let group = Group(
            openType: openGroupType,
            article: ArticleModel(
                articleTitle: articleTitle,
                location: city,
                postDate: Date.getCurrentDate(),
                content: articleContent
            ),
            products: products,
            userID: userId
            )
        
        return group
    }
    
    func translateProductPicsToUrl(group: Group, completion: @escaping (Group) -> Void) {
        
        for (index, value) in group.products.enumerated() {
            
            SVProgressHUD.show()

            guard let imageData = value.updateImage?.jpeg(.medium) else {
                
                BaseNotificationBanner.warningBanner(subtitle: "照片轉檔失敗")
                
                SVProgressHUD.dismiss()

                return
            }
            
            dispatchGroup.enter()
            
            firebaseManager.uploadProductPics(
                
                articleTitle: group.article.articleTitle,
                productName: value.productName,
                picture: imageData,
                sucess: { (url) in
                    
                    self.products[index].updateImage = nil
                    self.products[index].productImage = url.absoluteString
            
                    self.dispatchGroup.leave()
                    
                    self.dispatchGroup.notify(queue: .main) {
                        
                        completion(
                            Group(
                            openType: group.openType,
                            article: group.article,
                            products: self.products,
                            userID: group.userID
                            )
                        )
                    }
                    
            }) { (error) in
                
                SVProgressHUD.dismiss()

                #warning ("TODO")

            }
        }
        
    }
    
    @IBAction func uploadToServer(_ sender: UIButton) {
        
        guard let group = checkProductContent() else {
            return
        }
        
        SVProgressHUD.show()
        
        translateProductPicsToUrl(group: group) { (uploadGroup) in
            
            self.firebaseManager.uploadGroup(group: uploadGroup)
            
            SVProgressHUD.dismiss()
            BaseNotificationBanner.sucessBanner(subtitle: "上傳商品成功")
            self.resetViewWhenUploadSucess()
        }
    
    }
    
    func resetViewWhenUploadSucess() {
        
        products.removeAll()
        
        checkoutProductNumber()
        passCity(city: "選擇縣市")
        
        createArticle.contentTextView.text = ""
        createArticle.titleTxf.text = ""
        
        collectionView.reloadData()
        
    }
    
    @IBAction func cityBotTapping(_ sender: UIButton) {
        
        pickerViewBackgroundView.isHidden = false

        bottomConstriant.constant = -100
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func switchGroupType(_ sender: UISegmentedControl) {
        
        segmentedControl.changeUnderlinePosition()

        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
        
            openGroupType = .shareBuy
            
        case 1:
        
            openGroupType = .helpBuy
            
        default:
            
            openGroupType = .shareBuy
            
        }
        
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
        
        let width = collectionView.frame.size.width
        
        let height = collectionView.frame.size.height
        
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

extension OpenGroupViewController: PickerViewDelegate {
   
    func passCity(city: String) {
        
        pickerViewBackgroundView.isHidden = true
        
        bottomConstriant.constant = 280

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        }
        
        self.city = city
        createArticle.choseCityBot.setTitle(city, for: .normal)
    }
    
}
