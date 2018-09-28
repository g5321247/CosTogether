//
//  DetailViewController.swift
//  
//
//  Created by George Liu on 2018/9/25.
//

import UIKit
import FSPagerView

class DetailViewController: UIViewController, ProductPicDelegate {
    
    #warning ("TODO: Delete this")
    var testArray: [UIImage] = [#imageLiteral(resourceName: "test"), #imageLiteral(resourceName: "test2")]
    
    private lazy var sections: [CellClass] = [
        .productPic,
        .articleInfo,
        .joinGroup,
        .productItems(testArray.count),
        .order
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLogView: TopLogoView!
    
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
        
        registerTableViewCell(identifier: String(describing: ProductItemTableViewCell.self))
        registerTableViewCell(identifier: String(describing: ProductPicTableViewCell.self))
        registerTableViewCell(identifier: String(describing: ArticleInfoTableViewCell.self))
        registerTableViewCell(identifier: String(describing: OrderTableViewCell.self))
        registerTableViewCell(identifier: String(describing: JoinGroupTableViewCell.self))

    }
    
    private func registerTableViewCell(identifier: String) {

        let nibCell = UINib(nibName: identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: identifier)
        
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        tableView.allowsSelection = false
    }
    
    private func topLogViewSetup() {
        
        topLogView.backToPageBot.addTarget(self, action: #selector(backBotTapping(_:)), for: .touchUpInside)
        topLogView.sendMessageBot.addTarget(self, action: #selector(sendMessageBotTapping(_:)), for: .touchUpInside)
    }
    
    @objc func backBotTapping(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    #warning ("點選後直接進入與該使用者聊天")
    @objc func sendMessageBotTapping(_ sender: UIButton) {
        
    }
    
    #warning ("點作者進入個人資料")
    @objc func authorPhotoTapping(_ sender: UIButton) {
        
    }

}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
        
        switch sections[indexPath.section] {
            
        case .productPic:

            return self.view.frame.width * (3 / 5)
            
        case .articleInfo:
            
            return self.view.frame.width * (6 / 15)
            
        case .productItems:
            
            return 120
        
        case .order:
            
            return 85
            
        case .joinGroup:
            
            return 100
            
        default:
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch sections[section] {
            
//        case .productItems:
//
//            return self.view.frame.width * (40 / 375)
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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
            
            return cell
        
        case .joinGroup:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: JoinGroupTableViewCell.self)
                ) as? JoinGroupTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
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
            
        }
        
    }
    
}
