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
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ProductViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
//            collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: <#T##Subject#>), for: indexPath)
        
        return cell
    }
    
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {

    
    
    
}
