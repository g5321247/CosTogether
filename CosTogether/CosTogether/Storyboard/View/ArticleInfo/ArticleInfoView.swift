//
//  ArticleInfo.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ArticleInfoView: UIView {
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var articleTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        
        setupImageView()
    }
    
    private func setupImageView() {
        
        authorImage.cornerSetup(cornerRadius: authorImage.frame.width / 2)
    }

}
