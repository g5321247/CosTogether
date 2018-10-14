//
//  DetailViewController.swift
//  
//
//  Created by George Liu on 2018/9/25.
//

import UIKit
import FSPagerView
import Firebase
import NotificationBannerSwift

class DetailViewController: UIViewController, ProductPicDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLogView: TopLogoView!
    
    let firebaseManager = FirebaseManager()
    let dispatchGroup = DispatchGroup()
    
    func updateInfo(group: Group) {
        
        productPic.append(group)
        article.append(group)
        products = group.products
        order = group.products
        productDetail.append(group)
        
        for (index, _) in order.enumerated() {
         
            order[index].price = 0
            
        }
        

        firebaseManager.downloadCommentUser(group: group) { (comment) in
            
            self.comments.append(comment)
        }
        
        firebaseManager.downloadGroupUser(group: group) { (memberIds) in
         
            for value in memberIds {
                
                self.firebaseManager.userIdToGetUserInfo(userId: value) { (users) in
                    
                    self.joinMember.append(users)
                    self.tableView.reloadData()

                }
                
                self.checkUser(userId: value)
            }
                        
        }
        
        checkUser(userId: group.userID)

    }
    
    var productPic: [Group] = []
    
    var article: [Group] = []
    
    var joinMember: [UserModel] = []
    
    var products: [ProductModel] = []
    
    var order: [ProductModel] = []
    
    var productDetail: [Group] = []
    
    var comments: [CommentModel] = []
    
    lazy var allData: [DataType] = [
        DataType(dataType: .productPic, data: productPic),
        DataType(dataType: .articleInfo, data: article),
        DataType(dataType: .joinGroup, data: joinMember),
        DataType(dataType: .productItems(products.count), data: products),
        DataType(dataType: .order, data: order),
        DataType(dataType: .productDetail, data: productDetail),
        DataType(dataType: .commnetTitle, data: []),
        DataType(dataType: .previousComments(comments.count), data: comments),
        DataType(dataType: .sendComment, data: [])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        setUpCell()
        tableViewSetup()
        topLogViewSetup()
        
        Analytics.logEvent("LookProduct", parameters: nil)

    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: ProductItemTableViewCell.self),
            String(describing: ProductPicTableViewCell.self),
            String(describing: ArticleInfoTableViewCell.self),
            String(describing: OrderTableViewCell.self),
            String(describing: JoinGroupTableViewCell.self),
            String(describing: ProductDetailTableViewCell.self),
            String(describing: PreviousCommentTableViewCell.self),
            String(describing: CommonTitleTableViewCell.self),
            String(describing: SendCommentTableViewCell.self)
            ])
        
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        tableView.allowsSelection = false
    }
    
    private func topLogViewSetup() {
        
        topLogView.leftBot.addTarget(self, action: #selector(backBotTapping(_:)), for: .touchUpInside)
        topLogView.rightBot.addTarget(self, action: #selector(sendMessageBotTapping(_:)), for: .touchUpInside)
    }
    
    @objc func backBotTapping(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func sendMessageBotTapping(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.chatRoomStoryboard().instantiateViewController(
            withIdentifier: String(describing: ChatRoomViewController.self)
            ) as? ChatRoomViewController else {
                
                return
                
        }
        
        show(controller, sender: nil)
        
    }
    
    @objc func photoTapping(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self)
            ) as? ProfileViewController else {
                
                return
                
        }
        
        guard productPic.first?.userID != Auth.auth().currentUser?.uid else {
            
            #warning ("不要用數字判斷")
            self.tabBarController?.selectedIndex = 3

            return
        }
        
        guard let owner = productPic.first?.owner else {
            return
        }
        
        controller.loadViewIfNeeded()
        
        controller.checkOtherUser(
            averageEvaluation: owner.averageEvaluation ?? 0,
            userImage:  owner.userImage,
            buyNumber: owner.buyNumber ?? 0,
            userName: owner.userName,
            numberOfEvaluation: owner.numberOfEvaluation ?? 0,
            userType: .otherUser
        )
        
        
        show(controller, sender: nil)

    }
    
    func checkUser(userId: String) {
        
        guard userId != Auth.auth().currentUser?.uid else {
            
            guard let indexOfProduct = allData.firstIndex(
                where: {$0.dataType == .productItems(products.count)}
                ),
                let indexOfOrder = allData.firstIndex(
                    where: {$0.dataType == .productItems(products.count)}
                ) else {
                    
                return
                    
            }
            
            allData.remove(at: indexOfProduct)
            allData[indexOfOrder].data.removeAll()
            
            return

        }
        
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch  allData[indexPath.section].dataType {
            
        case .productPic:

            return self.view.frame.width * (3 / 5)
            
        case .articleInfo:
            
            return self.view.frame.width * (6 / 15)
            
        case .productItems:
            
            return  self.view.frame.width * (120 / 375)
        
        case .order:
            
            return  self.view.frame.width * (85 / 375)
            
        case .joinGroup:
            
            return  self.view.frame.width * (100 / 375)
        
        case .productDetail:
            
            return UITableView.automaticDimension
        
        case .commnetTitle:
            
            return  self.view.frame.width * (35 / 375)
        
        case .previousComments:
            
            return  UITableView.automaticDimension
        case .sendComment:
            
            return   self.view.frame.width * (53 / 375)

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch allData[section].dataType {
            
        case .productDetail:

            return self.view.frame.width * (15 / 375)
            
        case .commnetTitle:

            return self.view.frame.width * (15 / 375)
            
        default:
            return 0
        }
        
    }
            
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allData[section].dataType.numberOfRow()
    }

    // swiftlint:disable cyclomatic_complexity

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let allDataType = allData[indexPath.section]
        
        switch allDataType.dataType {
            
        case .productPic:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProductPicTableViewCell.self)
                ) as? ProductPicTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            cell.view.delegate = self

            cell.reloadProductPicView()
            
            return cell
            
        case .articleInfo:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ArticleInfoTableViewCell.self)
                ) as? ArticleInfoTableViewCell else {

                    return UITableViewCell()

            }

            cell.articleInfoView.updateArticle(groupArticle: allDataType.data[indexPath.row] as! Group)
            
            cell.articleInfoView.authorImageBot?.addTarget(
                self,
                action: #selector (photoTapping(_:)),
                for: .touchUpInside
            )

            return cell
        
        case .joinGroup:

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: JoinGroupTableViewCell.self)
                ) as? JoinGroupTableViewCell else {

                    return UITableViewCell()

            }

            cell.delegate = self
            cell.checkoutUserNumber()
            cell.collectionView.reloadData()
            
            return cell

        case .productItems:
        
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProductItemTableViewCell.self)
                ) as? ProductItemTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.productModel = allDataType.data[indexPath.row] as? ProductModel
            cell.updateView(product: allDataType.data[indexPath.row] as! ProductModel)
            
            cell.updatePurchasing { [weak self] (purchase) in
                
                self?.order[indexPath.row] = purchase
            
                guard let index = self?.allData.firstIndex(where: {$0.dataType == .order}),
                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: index)) as? OrderTableViewCell,
                let order = self?.order else {
                    
                    return
                }
                
                var totalCost = 0

                for value in order {
                    
                    totalCost += (value.price * value.numberOfItem)

                }
                
                cell.updateTotalPrice(totalCost: totalCost)

            }
            
            return cell
        
        case .order:
        
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: OrderTableViewCell.self)
                ) as? OrderTableViewCell else {
                    
                return UITableViewCell()
                    
            }
            
            guard  !allDataType.data.isEmpty else {
                
                cell.userHasJoined(title: "已加入揪團")
                
                return cell
            }
            
            
            cell.delegate = self
            
            var totalCost = 0
            
            for value in order {
                
                totalCost += (value.price * value.numberOfItem)
                
            }
            
            cell.updateTotalPrice(totalCost: totalCost)
        
            return cell
            
        case .productDetail:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProductDetailTableViewCell.self)
                ) as? ProductDetailTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            cell.productInfoLbl.text = productDetail.first?.article.content
            
            return cell
        
        case .commnetTitle:

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: CommonTitleTableViewCell.self)
                ) as? CommonTitleTableViewCell else {

                    return UITableViewCell()

            }

            return cell

        case .previousComments:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PreviousCommentTableViewCell.self)
                ) as? PreviousCommentTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            guard comments.count > 0 else {
                cell.noCommentSetup(title: "目前尚無留言")
                return cell
            }
            
            cell.updateComment(comment: comments[indexPath.row])
            
            return cell

        case .sendComment:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SendCommentTableViewCell.self)
                ) as? SendCommentTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            cell.delegate = self
            cell.baseView.delegate = self
            
            return cell

        }
        
    }
    
    // swiftlint:enable cyclomatic_complexity

}

extension DetailViewController: JoinGroupDelegate {
    
    func showTheView(controller: UIViewController) {
        
        show(controller, sender: nil)
        
    }
    
}

extension DetailViewController: CellDelegate {
    
    func updateLocalData(data: Any) {
        
        guard let text = data as? String else {
            
            return
        }
        
        guard let currentUser =  Auth.auth().currentUser else {
            
            return
            
        }
        
        let comment = CommentModel(
            postDate: Date.getCurrentDate(),
            comment: text,
            userId: currentUser.uid
        )

        firebaseManager.uploadComment(
            comment: comment,
            groupType: article.first!.openType,
            groupId: article.first!.groupId!
        )
        
        guard let sectionIndex = allData.firstIndex(where: {$0.dataType == .previousComments(comments.count)}) else {
            
            return
        }

        comments.append(comment)

        allData[sectionIndex] = DataType(
            dataType: .previousComments(comments.count),
            data: comments)
        
        self.tableView.reloadData()
    }
    
    func resizing(heightGap: CGFloat) {
        
        tableView.contentInset.bottom += heightGap
        tableView.contentOffset.y += heightGap
        
    }
    
    func cellButtonTapping(_ cell: UITableViewCell) {
        
        guard let currentUser =  Auth.auth().currentUser else {
            
            return
            
        }
        
        guard let sectionIndex = allData.firstIndex(where: {$0.dataType == .productItems(products.count)}) else {
                
                return
        }
        
        for (index) in products.indices {
            
            guard let cell = tableView.cellForRow(
                at: IndexPath(row: index, section: sectionIndex)
                ) as? ProductItemTableViewCell else {
                
                return
            }
            
            products[index].numberOfItem -= order[index].numberOfItem
            
            firebaseManager.uploadBuyer(
                buyerId: currentUser.uid,
                groupType: article[index].openType,
                groupId: article[index].groupId!,
                product: products[index],
                buyNumber: order[index].numberOfItem
            )
            
            order[index].numberOfItem = 0
            
            cell.updateView(product: products[index])

        }
        
        let banner = NotificationBanner(title: "加團成功", subtitle: "詳細資訊請到歷史紀錄區查詢", style: .success)
        banner.show()

        #warning ("加團失敗的警告")

        guard let index = allData.firstIndex(where: {$0.dataType == .joinGroup}),
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: index)) as? JoinGroupTableViewCell else {

                return
        }
        
        cell.checkoutUserNumber()
        
        //刪掉 cell 避免 fatal error
        checkUser(userId: currentUser.uid)
        
        cell.collectionView.reloadData()
        
        tableView.reloadData()
    }

}
