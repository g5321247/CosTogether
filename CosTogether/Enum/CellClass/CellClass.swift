//
//  CellClass.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/27.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

enum CellClass: Equatable {
    
    #warning ("把 comment 弄回來")
    
    case productPic
    case articleInfo
    case productItems(Int)
    case joinGroup
    case order
    case productDetail
    case commnetTitle
    case previousComments(Int)
    case sendComment
    
    func numberOfRow() -> Int {
        
        switch self {

        case .productItems (let number):
            
            return number
            
        case .previousComments (let number):
            
            return number
            
        default:
            
            return 1
        }
    }
    
    func cellForTableView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        switch self {
            
        default :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identified(), for: indexPath)
            
            return cell
            
        }
    }
    
    func identified() -> String {
        
        switch self {
            
        case .productPic:
            
            return String(describing: ProductPicTableViewCell.self)
        
        case .articleInfo:
        
            return String(describing: ArticleInfoTableViewCell.self)

        case .joinGroup:
            
            return String(describing: JoinGroupTableViewCell.self)

        case .productItems:
            
            return String(describing: ProductItemTableViewCell.self)
            
        case .order:
            
            return String(describing: OrderTableViewCell.self)
            
        case .productDetail:
            
            return String(describing: ProductDetailTableViewCell.self)
        
        case .commnetTitle:
            
            return String(describing: CommonTitleTableViewCell.self)
        
        case .previousComments:
            
            return String(describing: SendCommentTableViewCell.self)
            
        case .sendComment:
            
            return String(describing: SendCommentTableViewCell.self)
            
        }
        
    }
    
}
