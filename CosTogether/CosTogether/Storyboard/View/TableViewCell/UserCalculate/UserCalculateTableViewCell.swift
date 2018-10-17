//
//  UserCalculateTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/17.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class UserCalculateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageBot: UIButton!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pdoducts: [ProductModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func selfBuyerInfoUpdate(userName: String, useImage: String, pdoducts: [ProductModel]) {
        
        self.pdoducts = pdoducts
        
        var amount = 0
        
        for value in pdoducts {
            
            amount += value.price * value.numberOfItem
            
        }
        
        userNameLbl?.text = userName
        
        totalAmountLbl.text = "\(amount)"
        
        
        let url = URL(string: useImage)
        
        userImageBot.sd_setImage(with: url, for: .normal)
    }
    
    private func setup() {
        collectionviewSetup()
    }
    
    private func collectionviewSetup() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}


extension UserCalculateTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pdoducts.count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
            ) as? ProductCollectionViewCell else {
                
                print("No such cell")
                return UICollectionViewCell()
                
        }
        
        cell.updateMyProductInfo(
            numberOfItem: pdoducts[indexPath.row].numberOfItem,
            productName: pdoducts[indexPath.row].productName,
            price: pdoducts[indexPath.row].price,
            productImage: pdoducts[indexPath.row].productImage ?? ""
        )
        
        return cell
    }
    
}

extension UserCalculateTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 162.5 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width / 185.0 * 230
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15, left: 12, bottom: 10, right: 12)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
}
