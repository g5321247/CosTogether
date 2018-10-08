//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/5.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class OpenGroupViewController: UIViewController {

    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newProductBot: UIButton!
    @IBOutlet weak var inCollectionViewLbl: UILabel!
    
    var products: [String] = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        setup()

    }
    
    private func setup() {
        setColletionView()
        newProductBotSetup()
        
        guard products.count > 0 else {
            
            inCollectionViewLbl.isHidden = false
            
            return
        }
        
        inCollectionViewLbl.isHidden = true

    }
    
    private func setColletionView() {
        
        registerTableViewCell(identifier: String(describing: NewProductCollectionViewCell.self))
        
        collectionView.cornerSetup(cornerRadius: 4, borderWidth: 1, borderColor: UIColor.lightGray.cgColor)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        
    }
    
    private func newProductBotSetup() {
        
        newProductBot.cornerSetup(cornerRadius: 4, borderWidth: 2, borderColor: #colorLiteral(red: 0.1411764706, green: 0.3215686275, blue: 0.6196078431, alpha: 1), maskToBounds: true)
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }

    //   let banner = NotificationBanner(title: "加團成功", subtitle: "詳細資訊請到歷史紀錄區查詢", style: .success) banner.show()

    @IBAction func newProductBotTapping(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.appendProductItemStoryboard().instantiateInitialViewController() else {
            
            return
        }
        
        show(controller, sender: nil)
    }
    
}

extension OpenGroupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard products.count > 0 else {
            
            collectionView.isHidden = true
            return 0
        }
        
        collectionView.isHidden = false
        
        
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
        
        let width = 150.0 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width / 185.0 * 240
        
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
