//
//  CellClass.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/27.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

enum RefactorSection: Equatable {
    
    case productPic
    case articleInfo
    case productItems
    case joinGroup
    case order
    case productDetail
    case commnetTitle
    case previousComments
    case sendComment
    
    func numberOfRow() -> Int {
        
        switch self {
                        
        default:
            
            return 1
        }
    }
}

enum SectionType: Equatable {
        
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
    
    func tableView(_ controller: UIViewController, sendCommentHeight: CGFloat) -> CGFloat {
        
        switch  self {
            
        case .productPic:
            
            return controller.view.frame.width * (3 / 5)
            
        case .articleInfo:
            
            return controller.view.frame.width * (100 / 375)
            
        case .productItems:
            
            return  controller.view.frame.width * (90 / 375)
            
        case .order:
            
            return  controller.view.frame.width * (85 / 375)
            
        case .joinGroup:
            
            return  controller.view.frame.width * (105 / 375)
            
        case .productDetail:
            
            return UITableView.automaticDimension
            
        case .commnetTitle:
            
            return controller.view.frame.width * (35 / 375)
            
        case .previousComments:
            
            return  UITableView.automaticDimension
            
        case .sendComment:
            
            return sendCommentHeight
            
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
