//
//  OrderTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/28.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

protocol CellDelegate: AnyObject {
    
    func cellButtonTapping(_ cell: UITableViewCell)
    func resizing(heightGap: CGFloat)
    func updateLocalData(data: Any)
}

class OrderTableViewCell: UITableViewCell {

    weak var delegate: CellDelegate?
        
    @IBOutlet weak var orderBot: UIButton!
    @IBOutlet weak var amoutLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var hasJoinedLbl: UILabel!
    @IBOutlet weak var checkOrderInfoBot: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setup() {
        
        setButton()
        
    }
    
    private func setButton() {
        
        orderBot.cornerSetup(cornerRadius: 3)
        
    }
    
    func updateTotalPrice(totalCost: Int) {
        
        amoutLbl.text = String(totalCost) + " 元"
    }
    
    @IBAction func orderTapping(_ sender: UIButton) {
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            BaseNotificationBanner.warningBanner(subtitle: "匿名使用者無法下單，請用 FB 登入")
            return
        }
        
        guard Int.parse(from: amoutLbl.text!) != 0 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "您未加入任何商品")
            
            return
        }
        
        delegate?.cellButtonTapping(self)
        amoutLbl.text = "0 元"
    }
    
    func userHasJoined(title: String) {
        
        orderBot.isEnabled = false
        orderBot.isHidden = true
        
        amoutLbl.isHidden = true
        titleLbl.isHidden = true
        
        checkOrderInfoBot.isHidden = false
        checkOrderInfoBot.isEnabled = true
        
    }
    
}
