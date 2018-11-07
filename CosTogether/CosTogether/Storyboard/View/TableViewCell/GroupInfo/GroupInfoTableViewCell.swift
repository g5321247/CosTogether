//
//  GroupInfoTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

protocol GroupSettingDelegate: AnyObject {
    
    func getGroupTitle(title: String?)
    func getGroupInfo(info: String?)
    
}

class GroupInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var locationTxf: UITextField!
    @IBOutlet weak var titleTxf: UITextField!
    @IBOutlet weak var otherInfoTextView: UITextView!
    @IBOutlet weak var createGroupBot: UIButton!
    @IBOutlet weak var cancelBot: UIButton!
    
    weak var delegate: GroupSettingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
 
    private func textfieldDelegateSet() {
        
        otherInfoTextView.delegate = self
        titleTxf.delegate = self
        locationTxf.delegate = self
        
    }
    
    private func setup() {
        
        viewSetup()
        textfieldDelegateSet()
    }
    
    private func viewSetup() {
        
        locationTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        titleTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        otherInfoTextView.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        cancelBot.cornerSetup(cornerRadius: 4)
        createGroupBot.cornerSetup(cornerRadius: 4)
        
    }
    
}

extension GroupInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
            
        case locationTxf:
            
            textField.text = "台北"
            
        default:
            break
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard  let delegate = delegate,
            let text = textField.text,
            let textRange = Range(range, in: text) else {
                return true
        }
        
        switch textField {
            
        case titleTxf:
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            delegate.getGroupTitle(title: updatedText)

        default:
            break
        }
        
        return true
    }
    
}

extension GroupInfoTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let delegate = delegate,
            let text = textView.text,
            let textRange = Range(range, in: text) else {
                return true
        }

        let updatedText = text.replacingCharacters(in: textRange, with: text)

        delegate.getGroupInfo(info: updatedText)
        
        return true
    }
    
}
