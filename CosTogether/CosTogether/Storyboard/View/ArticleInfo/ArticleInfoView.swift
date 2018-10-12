//
//  ArticleInfo.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    func updateArticle(groupArticle: Group) {
        
        authorNameLbl?.text = groupArticle.owner?.userName
        
        postDateLbl.text = "發文日期：\n" + groupArticle.article.postDate
        
        locationLbl.text = groupArticle.article.location
        
        tagLbl.text = groupArticle.openType.rawValue
        
        articleTitleLbl.text = groupArticle.article.articleTitle

        guard let authorUrl = groupArticle.owner?.userImage,
            authorUrl != "" else {
            
                authorImageBot.imageView?.image = #imageLiteral(resourceName: "profile_sticker_placeholder02")
            
                return
        }
        
        let url = URL(string: authorUrl)
        authorImageBot.imageView?.sd_setImage(with: url)
        
    }
    
    func cornerup() {
        
        self.cornerSetup(cornerRadius: 8)
        
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
