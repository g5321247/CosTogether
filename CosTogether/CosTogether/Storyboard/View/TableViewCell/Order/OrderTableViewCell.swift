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
    func reszing(heightGap: CGFloat)
    func updateLocalData(data: Any)
}

class OrderTableViewCell: UITableViewCell {

    weak var delegate: CellDelegate?
        
    @IBOutlet weak var orderBot: UIButton!
    @IBOutlet weak var amoutLbl: UILabel!
    
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
        
        guard Int.parse(from: amoutLbl.text!) != 0 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "您未加入任何商品")
            
            return
        }
        
        #warning ("update to the bill,扣掉原單的數量")
        
        delegate?.cellButtonTapping(self)
        amoutLbl.text = "0 元"
    }
    
}
