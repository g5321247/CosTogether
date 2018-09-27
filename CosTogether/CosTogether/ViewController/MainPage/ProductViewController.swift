//
//  ProductCollectionViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
//    var products: [Product] = []
    var products: [Int] = [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        
        let identifier = String(describing: ProductCollectionViewCell.self)
        
        let xibCell = UINib(nibName: identifier, bundle: nil)
        
        collectionView.register(xibCell, forCellWithReuseIdentifier: identifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard products.count != 0 else {
            
            collectionView.isHidden = true
            
            return
        }
        
        collectionView.isHidden = false

    }
    
}

extension ProductViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
//            products.count
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
        
        return cell
    }
    
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 170.0 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width / 185.0 * 200 + 10
        
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
        
        return 15
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {

//        collectionView.deselectItem(at: indexPath, animated: true)

        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
            withIdentifier: String(describing: DetailViewController.self)
            ) as? DetailViewController else {
                
                return
                
        }
        
//        controller.loadViewIfNeeded()
//        controller.article = articles[indexPath.row]

        show(controller, sender: nil)
    }

}
