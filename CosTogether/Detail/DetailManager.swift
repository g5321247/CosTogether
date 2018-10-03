//
//  DetailManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

protocol DetailManagerDelegate: JoinGroupDelegate {
    
    var allData: [DataType] { get set }
    
}

class DetailManager: NSObject, UITableViewDelegate {
    
    weak var delegate: DetailManagerDelegate?
    
    var tableView: UITableView?
    
}

extension DetailManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        guard let delegate = delegate else {
            return 0
        }

        return delegate.allData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let delegate = delegate else {
            return 0
        }
        
        return delegate.allData[section].dataType.numberOfRow()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        
        guard let delegate = delegate else {
            
            return UITableViewCell()
            
        }
        
        let user = delegate.allData[indexPath.section]
        
        let cell = user.dataType.cellForTableView(tableView: tableView, indexPath: indexPath)
        
        switch user.dataType {
            
        case .articleInfo:
            
            guard let articleCell = cell as? ArticleInfoTableViewCell,
            let articleModel = user.data.first as? ArticleModel else {
                
                return cell
                
            }
            
            articleCell.articleInfoView.updateArticle(article: articleModel)
            
        case .joinGroup:
            
            guard let joinGroupCell = cell as? JoinGroupTableViewCell else {
                
                return cell
                
            }
            
            joinGroupCell.delegate = delegate
            
        case .order:
            
            guard let orderCell = cell as? OrderTableViewCell else {
                
                return cell
                
            }

            
        case .productDetail:
            
            guard let productGroupCell = cell as? JoinGroupTableViewCell else {
                
                return cell
                
            }

        case .previousComments:
            
            guard cell is PreviousCommentTableViewCell else {
                
                return cell
            }
            
        case .sendComment:
            
            guard cell is SendCommentTableViewCell else {
                
                return cell
            }
            
        case .productPic:
            
            guard let productCell = cell as? ProductPicTableViewCell else {
                
                return cell
            }
            
        case .productItems:
            
            guard let productItemCell = cell as? ProductItemTableViewCell,
                let productModel = user.data as? [ProductModel] else {
                
                return cell
            }
            
            productItemCell.productModel = productModel[indexPath.row]
         
        default:
            
            return cell
        }
    
        return cell
        
    }

}
