//
//  ArticleInfo.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ArticleInfoView: UIView {
    
    @IBOutlet weak var authorImageBot: UIButton!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var articleTitleLbl: UILabel!
    
    // 同一個 view 的判斷
    @IBOutlet weak var productImage: UIImageView?
    @IBOutlet weak var authorNameLbl: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateArticle(article: ArticleModel) {
        
        #warning ("用 sd 去設定 image")
//        authorImageBot.imageView?.image
        
        authorNameLbl?.text = article.user.userName
        
//        postDateLbl.text = article.postDate
        
        locationLbl.text = article.location
        
        #warning ("改成 Array")
        tagLbl.text = article.tag
        
        articleTitleLbl.text = article.articleTitle
        
    }
    
    private func setup() {
        
        setupImageView()
        setupView()
    }
    
    private func setupImageView() {
        
        authorImageBot.cornerSetup(cornerRadius: authorImageBot.frame.width / 2)
                
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
