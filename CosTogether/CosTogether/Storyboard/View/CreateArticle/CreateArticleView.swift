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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.delegate = self
        
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
            borderColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
            maskToBounds: true
        )
    }
    
    private func textSetup() {
        
        contentTextView.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: UIColor.lightGray.cgColor
        )
        
        contentTextView.text = "請輸入揪團詳細資訊內容..."
        contentTextView.textColor = UIColor.lightGray

        titleTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: UIColor.lightGray.cgColor
        )
        
    }
    
}

extension CreateArticleView: UITextViewDelegate {
  
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "請輸入揪團詳細資訊內容..."
            textView.textColor = UIColor.lightGray
            
        }
        
    }

}
