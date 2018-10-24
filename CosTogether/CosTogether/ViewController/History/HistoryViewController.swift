//
//  HistoryViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: TopLogoView!
    
    let firebaseManager = FirebaseManager()
    
    var joinMember: [UserModel] = []
    var group: [Group] = []
    var myProducts: [MyProduct] = []
    
    @IBOutlet weak var emptyTitleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        tableViewSetup()
        setUpCell()
        topLogViewSetup()
        
        downloadData(joinMember: joinMember)
    }
    
    private func downloadData(joinMember: [UserModel]) {
        
        for value in joinMember {
            
            guard let userId = value.userId,
            let group = group.first else {
                break
            }
            
            firebaseManager.filterUser(userId: userId, group: group) { (products) in
                
                let myProduct = MyProduct(user: value, products: products)
                
                self.emptyTitleLbl.isHidden = true
                
                self.myProducts.append(myProduct)
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    private func topLogViewSetup() {
        
        topView.leftBot.addTarget(self, action: #selector(backBotTapping(_:)), for: .touchUpInside)
    }

    @objc func backBotTapping(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: UserCalculateTableViewCell.self)
            ])
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadData() {
        
        tableView.reloadData()
    }
    
    
}

extension HistoryViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.view.frame.width / 375 * 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headercell =  Bundle.main.loadNibNamed(
            String(String(describing: UserCalculateHeader.self)),
            owner: self,
            options: nil
            )?.first as? UserCalculateHeader else {
                
                return nil
        }
        
//        headercell.selfBuyerInfoUpdate(userName: myProducts[section].user.userName, useImage: myProducts[section].user.userImage, pdoducts: myProducts[section].products)
        
        return headercell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        return self.view.frame.width / 375 * 50

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        guard let footerCell =  Bundle.main.loadNibNamed(
            String(String(describing: UserCalculateFooter.self)),
            owner: self,
            options: nil
            )?.first as? UserCalculateFooter else {
                
                return nil
        }
        
        //        headercell.selfBuyerInfoUpdate(userName: myProducts[section].user.userName, useImage: myProducts[section].user.userImage, pdoducts: myProducts[section].products)
        
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 25
    }
    
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserCalculateTableViewCell.self)) as? UserCalculateTableViewCell else {
            
            return UITableViewCell()
        }
        
//        cell.selfBuyerInfoUpdate(userName: myProducts[indexPath.row].user.userName, useImage: myProducts[indexPath.row].user.userImage, pdoducts: myProducts[indexPath.row].products)
        
        return cell
    }
    


}
