//
//  BaseCell.swift
//  
//
//  Created by George Liu on 2018/11/10.
//

import UIKit

extension UITableViewCell {
    
    static func createCell<T: UITableViewCell>(tableView: UITableView, indexPath: IndexPath) -> T {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath)
        
        return cell as! T
        
    }

}
