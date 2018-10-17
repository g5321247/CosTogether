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
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let width = 120 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width / 185.0 * 380
        
        return CGFloat(height)
        
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserCalculateTableViewCell.self)) as? UserCalculateTableViewCell else {
            
            return UITableViewCell()
        }
        
        cell.selfBuyerInfoUpdate(userName: myProducts[indexPath.row].user.userName, useImage: myProducts[indexPath.row].user.userImage, pdoducts: myProducts[indexPath.row].products)
        
        return cell
    }
    


}
