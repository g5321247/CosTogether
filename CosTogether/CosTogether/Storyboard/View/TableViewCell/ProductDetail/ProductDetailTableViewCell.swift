//
//  ProductDetailTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productInfoLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        
        baseViewSetup()
        
    }
    
    private func baseViewSetup() {
        
        baseView.cornerSetup(cornerRadius: 3, borderWidth: 0.6, borderColor: UIColor.black.cgColor, maskToBounds: false)
        baseView.shadowSetup()
        
    }
    
}
