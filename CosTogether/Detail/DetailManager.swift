//
//  DetailManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

protocol DetailManagerDelegate: AnyObject {
    
    var allData: [DataType] { get set }
    
}

class DetailManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: DetailManagerDelegate?
    
    var tableView: UITableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let delegate = delegate else {
            return 0
        }
        
        return delegate.allData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let delegate = delegate else {
            
            return UITableViewCell()
            
        }
        
        let user = delegate.allData[indexPath.section]
        
        let cell = user.dataType.cellForTableView(tableView: tableView, indexPath: indexPath)
        
        switch user.dataType {
            
        case .articleInfo:
            
            guard cell is ProductPicTableViewCell else {
                
                return cell
                
            }
            
            break
            
        case .commnetTitle:
            
            guard cell is ProductPicTableViewCell else {
                
                return cell
                
            }
            
            break
            
        case .joinGroup:
            
            guard cell is JoinGroupTableViewCell else {
                
                return cell
            }
            
            break
            
        case .order:
            
            guard cell is ProductItemTableViewCell else {
                
                return cell
            }
            
        case .productDetail:
            
            guard cell is ProductDetailTableViewCell else {
                
                return cell
            }
            
            break
            
        case .previousComments:
            
            guard cell is PreviousCommentTableViewCell else {
                
                return cell
            }
            
            break
            
        case .sendComment:
            
            guard cell is SendCommentTableViewCell else {
                
                return cell
            }
            
            break
        case .productPic:
            
            guard cell is ProductPicTableViewCell else {
                
                return cell
            }
            
            break
            
        case .productItems:
            
            guard cell is ProductItemTableViewCell else {
                
                return cell
            }
            
            break
            
        }
        
        return cell

    }
    
}
