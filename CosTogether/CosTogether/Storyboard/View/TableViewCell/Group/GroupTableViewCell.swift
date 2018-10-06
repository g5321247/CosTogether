//
//  GroupTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: ArticleInfoView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setup() {
        cornerCell()
        setShadow()
    }
    
    private func cornerCell() {
        
        baseView.cornerup()
        
    }
    
    private func setShadow() {
        
        shadowView.shadowSetup()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}
