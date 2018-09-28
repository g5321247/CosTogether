//
//  MemberCollectionViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/28.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var groupMemberBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setUp() {
         viewSetup()
         groupMemberSetup()
    }
    
    private func viewSetup() {

        baseView.cornerSetup(
            cornerRadius: bounds.width / 2,
            borderWidth: 0.5,
            borderColor: UIColor.lightGray.cgColor,
            maskToBounds: true
        )
        
    }

    private func groupMemberSetup() {

        groupMemberBot.cornerSetup(cornerRadius: bounds.width / 2)
        groupMemberBot.imageView?.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
}
