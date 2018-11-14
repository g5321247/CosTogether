//
//  UICollectionViewCell+.swift
//  CosTogether
//
//  Created by George Liu on 2018/11/10.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    static func createCell<T: UICollectionViewCell>(collectionView: UICollectionView, indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            
            fatalError("Missing \(String(describing: T.self)) in Storyboard")
        }
        
        return cell
        
    }
}

