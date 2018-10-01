//
//  ArticleInfo.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ArticleInfoView: UIView {
    
    @IBOutlet weak var authorImageBot: UIButton?
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setup() {
        
        setupImageView()
        setupView()
    }
    
    private func setupImageView() {
        
        guard let authorImageBot = authorImageBot else {
            return
        }
        
        authorImageBot.cornerSetup(cornerRadius: authorImageBot.bounds.width)
        
        authorImageBot.imageView?.contentMode = .scaleAspectFill
    }
    
    private func setupView() {
        
        self.shadowSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setup()

    }
    
}
