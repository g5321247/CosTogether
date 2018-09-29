//
//  ProfileViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userPicBaseView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
    }
    
    private func setup() {
        userImageSetup()
        userPicBaseViewSetup()
    }

    private func userImageSetup() {
        userImage.cornerSetup(cornerRadius: userImage.frame.width / 2)
    }
    
    private func userPicBaseViewSetup() {
        
        userPicBaseView.cornerSetup(
            cornerRadius: userPicBaseView.frame.width / 2,
            borderWidth: 2,
            borderColor: UIColor.gray.cgColor,
            maskToBounds: true
        )
        
        userPicBaseView.alpha = 0.9
        
    }

}
