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
    
    func updateGroupHistory(ownGroup: OwnGroup) {
        
        
        articleTitleLbl.text = ownGroup.group?.article.articleTitle
        
        guard let productUrl = ownGroup.products.first?.productImage else {
            return
        }
        
        let url = URL(string: productUrl)
        
        productImage?.sd_setImage(with: url)
        
    }
    
    func updateArticle(groupArticle: Group) {
        
        authorNameLbl?.text = groupArticle.owner?.userName
        
        postDateLbl.text = groupArticle.article.postDate
        
        locationLbl.text = groupArticle.article.location
        
        tagLbl.text = groupArticle.openType.rawValue
        
        guard let authorUrl = groupArticle.owner?.userImage,
            authorUrl != "" else {
            
                authorImageBot.imageView?.image = #imageLiteral(resourceName: "profile_sticker_placeholder02")
            
                return
        }
        
        let url = URL(string: authorUrl)
        
        authorImageBot.sd_setImage(with: url, for: .normal)
    }
    
    func cornerup() {
        
        self.cornerSetup(cornerRadius: 8)
        
    }
    
    private func setup() {
        
        setupImageView()
        setupView()
    }
    
    private func setupImageView() {
        
        authorImageBot.imageView?.layer.cornerRadius = authorImageBot.imageView!.frame.width / 2
        
        authorImageBot.imageView?.contentMode = .scaleAspectFill
    }
    
    private func setupView() {
        
        self.shadowSetup()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        setupImageView()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupImageView()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setup()
        setupImageView()
    }
    
}
