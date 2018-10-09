//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/5.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import FSPagerView

class OpenGroupViewController: UIViewController {

    @IBOutlet weak var newProductBot: UIButton!
    @IBOutlet weak var inCollectionViewLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [ProductModel] = []
//    var products: [UIImage] = [#imageLiteral(resourceName: "testUser"),#imageLiteral(resourceName: "testUser2"),#imageLiteral(resourceName: "test")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setup()
        collectionView.reloadData()

    }
    
    private func setup() {
        
        newProductBotSetup()
        setColletionView()
        
        guard products.count > 0 else {

            inCollectionViewLbl.isHidden = false

            return
        }

        inCollectionViewLbl.isHidden = true
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.clipsToBounds = true
    }
    
    private func setColletionView() {
        
        registerTableViewCell(identifier: String(describing: NewProductCollectionViewCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        collectionView.cornerSetup(
            cornerRadius: 0,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
            maskToBounds: false
        )
        
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }

    private func newProductBotSetup() {
        
        newProductBot.cornerSetup(cornerRadius: 4, borderWidth: 2, borderColor: #colorLiteral(red: 0.1411764706, green: 0.3215686275, blue: 0.6196078431, alpha: 1), maskToBounds: true)
    }
    
    //   let banner = NotificationBanner(title: "加團成功", subtitle: "詳細資訊請到歷史紀錄區查詢", style: .success) banner.show()

    @IBAction func newProductBotTapping(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.appendProductItemStoryboard()
            .instantiateInitialViewController()
            as? AppendNewItemViewController else {
            
            return
        }
        
        controller.appendProduct { (product) in
            
            #warning ("要把 update image 上傳至 firebase ")
//            self.products.append(product)
        }
        
        show(controller, sender: nil)
    }
    
}

extension OpenGroupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        return products.count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: NewProductCollectionViewCell.self),
            for: indexPath
            ) as? NewProductCollectionViewCell else {
                
                print("No such cell")
                return UICollectionViewCell()
                
        }
        
        return cell
    }
    
}

extension OpenGroupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 170.0 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width / 185.0 * 220
        
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
        
        guard let controller = UIStoryboard.detailStoryboard().instantiateViewController(
            withIdentifier: String(describing: DetailViewController.self)
            ) as? DetailViewController else {
                
                return
                
        }
        
        #warning ("傳姪過去")
        //        controller.loadViewIfNeeded()
        //        controller.article = articles[indexPath.row]
        
        show(controller, sender: nil)
    }
    
}
