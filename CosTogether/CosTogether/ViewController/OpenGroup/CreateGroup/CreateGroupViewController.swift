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

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var topTitleLbl: UILabel!
    @IBOutlet weak var newProductBot: UIButton!
    @IBOutlet weak var numberOfProductCategoryLbl: UILabel!
    @IBOutlet weak var bottomConstriant: NSLayoutConstraint!
    @IBOutlet weak var pickerViewBackgroundView: UIView!
    @IBOutlet weak var createArticle: CreateArticleView!
    @IBOutlet weak var pickerView: PickerView!
    @IBOutlet weak var collectionBackgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let refrence = Database.database().reference()

    let dispatchGroup = DispatchGroup()
    
    var key: String?
    
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
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsSelection = false
        setUpCell()
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: ImageTableViewCell.self),
            String(describing: GroupInfoTableViewCell.self)
            ])
    }

    
    private func setup() {
        
        pickerViewBackgroundView.isHidden = true
        pickerView.delegate = self
        
        makeKey()
        
        tableViewSetup()
    }
    
    private func makeKey() {
        
        guard let autoKey = refrence.childByAutoId().key else {
            
            #warning ("上傳失敗警告")
            
            return
        }
        
        key = autoKey
    }
    
    private func checkoutProductNumber() {
        
        guard products.count > 0 else {
            
            return
        }
        

    }
    
    @IBAction func backToRootViw(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func appendProductBotTapping(_ sender: UIButton) {
        
        guard let controller = goToAppendProduct() as? AppendNewItemViewController else {
            
            return
        }
        
        controller.appendProduct { (product) in
            
            self.products.append(product)
            BaseNotificationBanner.sucessBanner(subtitle: "商品新增成功")

            self.tableView.reloadData()
            self.checkoutProductNumber()
            
        }
        
        show(controller, sender: nil)
    }
    
    private func goToAppendProduct() -> UIViewController? {
        
        guard let controller = UIStoryboard.appendProductItemStoryboard()
            .instantiateViewController(withIdentifier: "appendProductItem")
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
        
        guard let articleContent = createArticle.contentTextView.text else {
                
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
   
    func resetViewWhenUploadSucess() {
        
        products.removeAll()
        
        checkoutProductNumber()
        passCity(city: "選擇縣市")
        
        createArticle.contentTextView.text = ""
        createArticle.titleTxf.text = ""
        
        tableView.reloadData()
        
    }
    
    @IBAction func cityBotTapping(_ sender: UIButton) {
        
        pickerViewBackgroundView.isHidden = false

        bottomConstriant.constant = -100
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @objc func cancelBotTapping(_ sender: UIButton) {
        
        self.resetViewWhenUploadSucess()
        
    }
    
}

//
//extension CreateGroupViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = collectionView.frame.size.width
//
//        let height = collectionView.frame.size.height
//
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 15
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 8
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didSelectItemAt indexPath: IndexPath) {
//
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        guard let controller = goToAppendProduct() as? AppendNewItemViewController else {
//
//            return
//        }
//
//        controller.loadViewIfNeeded()
//
//       let sheet = alertSheet(
//            controller: controller,
//            product: products[indexPath.row],
//            indexPath: indexPath
//        )
//
//        self.present(sheet, animated: true, completion: nil)
//    }
//
//    private func alertSheet(
//        controller: AppendNewItemViewController,
//        product: ProductModel,
//        indexPath: IndexPath
//        ) -> UIAlertController {
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        let editAction = UIAlertAction(title: "編輯商品", style: .default) { (_) in
//
//            controller.editProductDetail(product: product)
//
//            controller.appendProduct(product: { [weak self] (product) in
//
//                self?.products[indexPath.row] = product
//
//                BaseNotificationBanner.sucessBanner(
//                    subtitle: "商品修改成功",
//                    style: .info
//                )
//
//                self?.collectionView.reloadData()
//            })
//
//            self.show(controller, sender: nil)
//        }
//
//        let deleteAction = UIAlertAction(title: "刪除商品", style: .default) { (_) in
//
//            self.products.remove(at: indexPath.row)
//            self.collectionView.reloadData()
//
//            BaseNotificationBanner.sucessBanner(
//                subtitle: "商品刪除成功",
//                style: .info
//            )
//
//            self.checkoutProductNumber()
//
//        }
//
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//
//        alertController.addAction(editAction)
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//
//        return alertController
//    }
//
//}

extension CreateGroupViewController: PickerViewDelegate {
   
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

extension CreateGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0:
            
            return 212
        
        case 1:
            
            return 212
        
        case 2:
            
            return 430
            
        default:
            return 0
        }
    }
    
    
}

extension CreateGroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        
        case 0:
            
            return products.count
        
        case 1:
            
            return 1
        
        case 2:
            
            return 1
        
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self)) as? ImageTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.updateProduct(product: products[indexPath.row])
            
            return cell
        
        case 1:
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self)) as? ImageTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.addBot.addTarget(self, action: #selector (appendProductBotTapping(_:)), for: .touchUpInside)
            
            return cell

        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupInfoTableViewCell.self)) as? GroupInfoTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.createGroupBot.addTarget(self, action: #selector(uploadNewGroup(_:)), for: .touchUpInside)
            cell.cancelBot.addTarget(self, action: #selector (cancelBotTapping(_:)), for: .touchUpInside)
            
            return  cell
            
            
        default:
            
            return UITableViewCell()
            
        }
        
    }
    
    
}

// MARK: Create a Group

extension CreateGroupViewController {

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
                    
            }) { (error) in
                
                SVProgressHUD.dismiss()
                
                #warning ("TODO")
                
                self.dispatchGroup.leave()
                
            }
            
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
        }
        
    }
    
    @objc func uploadNewGroup(_ sender: UIButton) {
        
        guard let group = checkProductContent(),
            let key = key else {
                return
        }
        
        SVProgressHUD.show()
        
        translateProductPicsToUrl(group: group) { (uploadGroup) in
            
            self.firebaseManager.uploadGroup(refrence: self.refrence, group: uploadGroup, key: key)
            
            SVProgressHUD.dismiss()
            BaseNotificationBanner.sucessBanner(subtitle: "上傳商品成功")
            
            self.resetViewWhenUploadSucess()
            
            NotificationCenter.default.post(name: .createNewGroup, object: nil, userInfo: nil)
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }

}
