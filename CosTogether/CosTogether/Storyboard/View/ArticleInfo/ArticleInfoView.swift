//
//  ArticleInfo.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SDWebImage

protocol GroupManagerProtocol {
    
    var openType: OpenGroupType? { get set }
    var article: ArticleModel { get set }
    var products: [ProductModel] { get set }
    var owner: UserModel? { get set }
    var memberID : [String]? { get set }
    var groupId: String? { get set }
    
}

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
    
    func updateArticle(group: GroupManagerProtocol) {
        
        authorNameLbl?.text = group.owner?.userName
        
        postDateLbl.text = group.article.postDate
        
        locationLbl?.text = group.article.location
        
        guard let openType = group.openType else {
            return
        }

        tagLbl?.text = openType.rawValue
        
        guard let authorUrl = group.owner?.userImage,
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
    }
    
    private func setupImageView() {
        
        authorImageBot.imageView?.layer.cornerRadius = authorImageBot.imageView!.frame.width / 2
        
        authorImageBot.imageView?.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setup()
        setupImageView()
    }
    
}
