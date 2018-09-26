//
//  ProductPicView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductPicView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        
        setupImageView()
    }
    
    private func setupImageView() {
        
        self.cornerSetup(cornerRadius: 0,
                         borderWidth: 0.8,
                         borderColor: UIColor.gray.cgColor,
                         maskToBounds: false)
        
        self.shadowSetup(
        cgSize: CGSize(width: 1, height: 1),
        shadowRadius: 2,
        shadowOpacity: 0.2
        )
        
    }
    
    
    
}
