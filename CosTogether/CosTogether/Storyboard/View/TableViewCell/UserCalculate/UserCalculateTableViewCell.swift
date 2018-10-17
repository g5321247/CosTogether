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
        
        collectionView.reloadData()
    }
    
    private func setup() {
        collectionviewSetup()
    }
    
    private func collectionviewSetup() {
        
        registerTableViewCell(identifier: String(describing: MyProductCollectionViewCell.self))

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }

    }

    
}


extension UserCalculateTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = pdoducts.count
        
        return count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        print("yo")
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: MyProductCollectionViewCell.self),
            for: indexPath
            ) as? MyProductCollectionViewCell else {
                
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
        
        let width = 120 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width / 185.0 * 180
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
}
