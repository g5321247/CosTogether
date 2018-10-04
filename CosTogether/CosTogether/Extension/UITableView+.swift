//
//  UIViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/30.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UITableView {
    
     func registerTableViewCell(identifiers: [String]) {
        
        let identifierArray = identifiers
        
        for identifier in identifierArray {
            
            let nibCell = UINib(nibName: identifier, bundle: nil)
            self.register(nibCell, forCellReuseIdentifier: identifier)
            
        }
    }

}
