//
//  ProductPicTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/27.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductPicTableViewCell: UITableViewCell{
    
    @IBOutlet weak var view: ProductPicView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func reloadProductPicView() {
        
        view.setup()
        
    }
    
}
