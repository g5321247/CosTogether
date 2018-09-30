//
//  DetailViewController.swift
//  
//
//  Created by George Liu on 2018/9/25.
//

import UIKit
import FSPagerView

struct Name {
    let name: String
}

class DetailViewController: UIViewController, ProductPicDelegate {
    
    #warning ("TODO: 改成 Struct")
    var testArray: [UIImage] = [#imageLiteral(resourceName: "test"), #imageLiteral(resourceName: "test2")]
    var testComment:[String] = ["123", "主揪好帥", "臣亮言：先帝創業未半，而中道崩殂。今天下三分，益州 疲弊，此誠危急存亡之秋也。然侍衛之臣，不懈於內；忠志之 士，忘身於外者，蓋追先帝之殊遇，欲報之於陛下也。誠宜開 張聖聽，以光先帝遺德，恢弘志士之氣"]
        
    private lazy var sections: [CellClass] = [
        .productPic,
        .articleInfo,
        .joinGroup,
        .productItems(testArray.count),
        .order,
        .productDetail,
        .commnetTitle,
        .previousComment(testComment.count),
        .sendComment
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLogView: TopLogoView!
    
    var author: UserDataModel = UserDataModel(
        userImage: "testUser",
        userName: "金城武",
        numberOfEvaluation: 2,
        buyNumber: 3,
        averageEvaluation: 5.0
        )
    
    var members: [UserDataModel] = [
        UserDataModel(
            userImage: "testUser2",
            userName: "林志玲",
            numberOfEvaluation: 100,
            buyNumber: 4,
            averageEvaluation: 5.0
        ),
        UserDataModel(
            userImage: "",
            userName: "白目",
            numberOfEvaluation: 1000,
            buyNumber: 999,
            averageEvaluation: 1.2
        )]
    
    var comment: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setup() {
        
        setUpCell()
        tableViewSetup()
        topLogViewSetup()
    }
    
    private func setUpCell() {
        
        registerTableViewCell(identifiers: [
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
    
    private func registerTableViewCell(identifiers: [String]) {

        let identifierArray = identifiers
        
        for identifier in identifierArray {
            
            let nibCell = UINib(nibName: identifier, bundle: nil)
            tableView.register(nibCell, forCellReuseIdentifier: identifier)

        }
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
    
    #warning ("點選後直接進入與該使用者聊天")
    @objc func sendMessageBotTapping(_ sender: UIButton) {
        
    }
    
    #warning ("如何用在同一個 function")
    @objc func photoTapping(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self)
            ) as? ProfileViewController else {
                
                return
                
        }
        
        
//        guard let cell = sender.superview?.superview?.superview as? ArticleInfoTableViewCell else {
//
//            return
//        }
        controller.otherUserInfo = author
        controller.userType = .otherUser
        
        controller.loadViewIfNeeded()
        
        show(controller, sender: nil)

    }
    

}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch sections[indexPath.section] {
            
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
        
        case .previousComment:
            
            return  UITableView.automaticDimension
        case .sendComment:
            
            tableView.layoutIfNeeded()
            return UITableView.automaticDimension

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch sections[section] {
            
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
            
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
            
            cell.articleInfoView.authorImageBot.addTarget(
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
            
            return cell

        case .productItems:
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProductItemTableViewCell.self)
            ) as? ProductItemTableViewCell else {
                
                return UITableViewCell()
                
        }
                    
            cell.productImage.image = testArray[indexPath.row]
        
            return cell
        
        case .order:
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: OrderTableViewCell.self)
            ) as? OrderTableViewCell else {
                    
                return UITableViewCell()
                    
        }
                        
            return cell
            
        case .productDetail:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProductDetailTableViewCell.self)
                ) as? ProductDetailTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            return cell
        
        case .commnetTitle:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: CommonTitleTableViewCell.self)
                ) as? CommonTitleTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            return cell

        case .previousComment:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PreviousCommentTableViewCell.self)
                ) as? PreviousCommentTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            cell.commentLbl.text = testComment[indexPath.row]
            
            return cell

        case .sendComment:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SendCommentTableViewCell.self)
                ) as? SendCommentTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            return cell

        }
        
    }
    
}

extension DetailViewController: JoinGroupDelegate {
    
    func showTheView(controller: UIViewController) {
        
        show(controller, sender: nil)
        
    }
    
}
