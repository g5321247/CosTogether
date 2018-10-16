//
//  HistoryViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    private func setup() {
        
        tableViewSetup()

    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    func reloadData() {
        
        allData = [
            DataType(dataType: .productPic, data: productPic),
            DataType(dataType: .articleInfo, data: article),
            DataType(dataType: .joinGroup, data: joinMember),
            DataType(dataType: .productItems(products.count), data: products),
            DataType(dataType: .productDetail, data: productDetail),
            DataType(dataType: .commnetTitle, data: []),
            DataType(dataType: .previousComments(comments.count), data: comments),
            DataType(dataType: .sendComment, data: [])
        ]
        
        tableView.reloadData()
    }
    
    var productPic: [Group] = []
    
    var article: [Group] = []
    
    var joinMember: [UserModel] = []
    
    var products: [ProductModel] = []
    
    var productDetail: [Group] = []
    
    var comments: [CommentModel] = []
    
    lazy var allData: [DataType] = []
    

    
}

extension HistoryViewController: UITableViewDelegate {
    
}

//extension HistoryViewController: UITableViewDataSource {
//
//
//}
