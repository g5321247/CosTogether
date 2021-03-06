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
    @IBOutlet var pickerView: PickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var cell: GroupInfoTableViewCell?
    
    let refrence = Database.database().reference()

    let dispatchGroup = DispatchGroup()
    
    var key: String?
    
    var products: [ProductModel] = []
    
    var openGroupType: OpenGroupType = .shareBuy

    var groupTitle: String?
    var city: String?
    var groupInfo: String?
    
    let firebaseManager = FirebaseManager.shared
    
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
        
        tableView.allowsSelection = true
        setUpCell()
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: ImageTableViewCell.self),
            String(describing: GroupInfoTableViewCell.self)
            ])
    }

    
    private func setup() {
        
        pickerView.delegate = self
        
        makeKey()
        tableViewSetup()
    }
    
    private func makeKey() {
        
        guard let autoKey = refrence.childByAutoId().key else {
            
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
        
        guard let articleTitle = groupTitle,
            articleTitle != "" else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入標題")
                
                return nil
        }
        
        guard let city = city else {
            
            BaseNotificationBanner.warningBanner(subtitle: "請選擇城市")
            
            return nil

        }
        
        guard let articleContent = groupInfo else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入詳細資訊內容")
                
                return nil
        }
        
        guard products.count > 0 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "商品品項不得為零")
            
            return nil

        }
        
        guard let user = UserManager.shared.userInfo() else {
            
            BaseNotificationBanner.warningBanner(subtitle: "使用者無發文權利")
            
            return nil
        }
        
        let owner = UserModel(
            userImage: user.userPicURL,
            userName: user.userName,
            userId: user.userId
            )
        
        let group = Group(
            openType: openGroupType,
            article: ArticleModel(
                title: articleTitle,
                location: city,
                postDate: Date.getCurrentDate(),
                content: articleContent
            ),
            products: products,
            owner: owner
            )
        
        return group
    }
   
    func resetViewWhenUploadSucess() {
        
        products.removeAll()
        
        checkoutProductNumber()
        passCity(city: "選擇縣市")
        
        guard let cell = cell else {
            return
        }
        
        cell.locationTxf.text = ""
        cell.otherInfoTextView.text = ""
        cell.titleTxf.text = ""
        
        tableView.reloadData()
        
    }
    
    @objc func cancelBotTapping(_ sender: UIButton) {
        
        self.resetViewWhenUploadSucess()
        
    }
    
}

extension CreateGroupViewController: PickerViewDelegate {
   
    func passCity(city: String) {
        
        self.city = city
        
        guard let cell = cell else {
            
            return
        }
        
        cell.locationTxf.text = city
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
            
        case 0:
            
            guard let controller = goToAppendProduct() as? AppendNewItemViewController else {
    
                return
            }
    
            controller.loadViewIfNeeded()
    
           let sheet = editProduct(
                controller: controller,
                product: products[indexPath.row],
                indexPath: indexPath
            )
    
            self.present(sheet, animated: true, completion: nil)
        
        default:
            break
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
            
            let cell: ImageTableViewCell = UITableViewCell.createCell(tableView: tableView, indexPath: indexPath)
            
            cell.updateProduct(product: products[indexPath.row])
            cell.productImageBot.isEnabled = false
            cell.productImageBot.adjustsImageWhenDisabled = false
            
            return cell
        
        case 1:
        
            let cell: ImageTableViewCell = UITableViewCell.createCell(tableView: tableView, indexPath: indexPath)

            cell.clear()
            
            cell.addBot.addTarget(self, action: #selector (appendProductBotTapping(_:)), for: .touchUpInside)
            
            cell.productImageBot.addTarget(self, action: #selector (appendProductBotTapping(_:)), for: .touchUpInside)
            
            return cell

        case 2:
            
            let cell: GroupInfoTableViewCell = UITableViewCell.createCell(tableView: tableView, indexPath: indexPath)
            
            self.cell = cell
            
            cell.delegate = self
            
            cell.locationTxf.inputView = pickerView
            
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
                
                articleTitle: group.article.title,
                productName: value.productName,
                picture: imageData,
                sucess: { [weak self] (url) in
                    
                    guard let self = self else {
                        
                        return
                    }
                    
                    self.products[index].updateImage = nil
                    self.products[index].productImage = url.absoluteString
                    
                    self.dispatchGroup.leave()
                    
            }) { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                SVProgressHUD.dismiss()
                                
                self.dispatchGroup.leave()
                
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
            
            guard let openType = group.openType,
                let owner = group.owner else {
                    return
            }
            
            completion(
                Group(
                    openType: openType,
                    article: group.article,
                    products: self.products,
                    owner: owner
                )
            )
        }
        
    }
    
    @objc func uploadNewGroup(_ sender: UIButton) {
        
        guard let group = checkProductContent(),
            let key = key else {
                return
        }
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
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

extension CreateGroupViewController: GroupSettingDelegate {
   
    func getGroupTitle(title: String?) {
        
        groupTitle = title
        
    }
    
    func getGroupInfo(info: String?) {
        
        groupInfo = info
    }
    
}

extension CreateGroupViewController {

    private func editProduct(
        controller: AppendNewItemViewController,
        product: ProductModel,
        indexPath: IndexPath
        ) -> UIAlertController {
        
        let alertController = UIAlertController.showActionSheet(
        defaultOption: ["編輯商品", "刪除商品"]) { [weak self] (action) in
            
            switch action.title {
                
            case "編輯商品":
                
                controller.editProductDetail(product: product)
                
                controller.appendProduct(product: { [weak self] (product) in
                    
                    self?.products[indexPath.row] = product
                    
                    BaseNotificationBanner.sucessBanner(
                        subtitle: "商品修改成功",
                        style: .info
                    )
                    
                    self?.tableView.reloadData()
                })
                
                self?.show(controller, sender: nil)
            
            case "刪除商品":
                
                self?.products.remove(at: indexPath.row)
                self?.tableView.reloadData()
                
                BaseNotificationBanner.sucessBanner(
                    subtitle: "商品刪除成功",
                    style: .info
                )
                
                self?.checkoutProductNumber()
                
            default:
                break
            }
            
        }
        
        return alertController
    }

}
