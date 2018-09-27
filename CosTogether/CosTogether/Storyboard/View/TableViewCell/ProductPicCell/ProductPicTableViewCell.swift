//
//  ProductPicTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/27.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductPicTableViewCell: UITableViewCell,ProductPicDelegate {
    
    var testArray: [UIImage] = [#imageLiteral(resourceName: "test"),#imageLiteral(resourceName: "test2")]

//    var products: [Product] = []
    
    @IBOutlet weak var view: ProductPicView!

    override func awakeFromNib() {
        super.awakeFromNib()
        view.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
