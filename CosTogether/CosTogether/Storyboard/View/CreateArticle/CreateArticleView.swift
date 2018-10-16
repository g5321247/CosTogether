//
//  CreateArticleView.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/6.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class CreateArticleView: UIView {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTxf: UITextField!
    @IBOutlet weak var choseCityBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTxf.delegate = self
        contentTextView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()

    }

    private func setup() {
        
        textSetup()
        viewSetup()
    }
    
    private func viewSetup() {
        
        self.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            maskToBounds: true
        )
                
    }
    
    private func textSetup() {
        
        contentTextView.cornerSetup(
            cornerRadius: 0,
            borderWidth: 0.5,
            borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        )
        
        contentTextView.text = "請輸入揪團詳細資訊內容..."
        contentTextView.textColor = UIColor.lightGray

        titleTxf.cornerSetup(
            cornerRadius: 0,
            borderWidth: 0.5,
            borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        )
        
    }
    
}

extension CreateArticleView: UITextViewDelegate {
  
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        CosNavigationControllerViewController.isLightStatusBar = true
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        CosNavigationControllerViewController.isLightStatusBar = true
        
        if textView.text.isEmpty {
            
            textView.text = "請輸入揪團詳細資訊內容..."
            textView.textColor = UIColor.lightGray
            
        }
        
    }

}

extension CreateArticleView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        CosNavigationControllerViewController.isLightStatusBar = true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        CosNavigationControllerViewController.isLightStatusBar = true

    }
}
