//
//  GroupTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SDWebImage

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateGroupHistory(ownGroup: OwnGroup) {
        
        articleTitleLbl.text = ownGroup.group?.article.articleTitle
        
        postDateLbl.text = ownGroup.group?.article.postDate
        
        guard let productUrl = ownGroup.products.first?.productImage else {
            return
        }
        
        let url = URL(string: productUrl)
        
        productImage?.sd_setImage(with: url)
        
    }

}
