//
//  ProductBaseViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/11/8.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProductBaseViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyTitle: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    let firebaseManager = FirebaseManager.shared
    
    var openGroupType: OpenGroupType = .shareBuy
    
    let userDefault = UserDefaults.standard
    
    var group: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    @objc func refresh(_ sender: UIButton) {
        
        group.removeAll()
        
        self.refreshControl.beginRefreshing()
        
        firebaseManager.downloadGroup(groupType: openGroupType) { [weak self] (groupData) in
            
            guard let self = self else {
                return
            }
            
            guard self.userDefault.integer(forKey: groupData.owner!.userId) != 1 else {
                
                self.collectionView.reloadData()
                
                return
            }
            
            self.group.insert(groupData, at: 0)
            
            self.collectionView.reloadData()
            
        }
    }
    
    
    private func setup() {
        
        setColletionView()
        downloadData()
        
        SVProgressHUD.dismiss()
        
    }
    
    private func setColletionView() {
        
        registerTableViewCell(identifier: String(describing: ProductCollectionViewCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        
        refreshControl = UIRefreshControl()
        
        collectionView.alwaysBounceVertical = true
        
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料中...")
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)
        
    }
    
    private func downloadData() {
        
        SVProgressHUD.show()
        
        firebaseManager.downloadGroup(groupType: openGroupType) { [weak self] (groupData) in
            
            guard let self = self else {
                return
            }
            
            guard self.userDefault.integer(forKey: groupData.owner!.userId) != 1 else {
                return
            }
            
            self.group.insert(groupData, at: 0)
            
            self.collectionView.reloadData()
        }
        
        firebaseManager.detectChildRemove(openGroupType: openGroupType) { [weak self] (keys) in
            
            guard let self = self else {
                return
            }
            
            for (index, key) in keys.enumerated() {
                
                for value in self.group {
                    
                    guard let id = value.groupId else {
                        continue
                    }
                    
                    if key == id {
                        
                        self.group.remove(at: index)
                        continue
                    }
                    
                }
                
            }
            self.collectionView.reloadData()
        }
        
        self.collectionView.reloadData()
        
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }
    
}

extension ProductBaseViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard group.count > 0 else {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                
                self.refreshControl.endRefreshing()
                
            }
            
            emptyTitle.isHidden = false
            
            return 0
            
        }
        
        collectionView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            
            self.refreshControl.endRefreshing()
            
        }
        
        emptyTitle.isHidden = true
        
        return group.count
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        
        let cell: ProductCollectionViewCell = UICollectionViewCell.createCell(collectionView: collectionView, indexPath: indexPath)
        
        cell.updateGroupInfo(
            productUrl: group[indexPath.row].products.first?.productImage ?? "",
            authorUrl: group[indexPath.row].owner?.userImage ?? "",
            title:  group[indexPath.row].article.title,
            location: group[indexPath.row].article.location,
            postDate:  group[indexPath.row].article.postDate
        )
        
        return cell
    }
    
}

extension ProductBaseViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        //        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let controller = UIStoryboard.detailStoryboard().instantiateViewController(
            withIdentifier: String(describing: DetailViewController.self)
            ) as? DetailViewController else {
                
                return
                
        }
        
        controller.loadViewIfNeeded()
        controller.updateInfo(group: group[indexPath.row])
        
        show(controller, sender: nil)
    }
    
  
}
