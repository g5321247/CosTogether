//
//  ProductCollectionViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShareBuyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let firebaseManager = FirebaseManager()
    
    var openGroupType: OpenGroupType = .shareBuy
    
    @IBOutlet weak var emptyTitle: UILabel!

    var group: [Group] = [] {
        
        didSet {
            print("no")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    private func notiSetup() {
        
        let notificationName = Notification.Name("createNewGroup")
        NotificationCenter.default.addObserver(self, selector: #selector (downloadFromFirebase(noti:)), name: notificationName, object: nil)
        
    }
    
    @objc func downloadFromFirebase(noti: Notification) {
        
        group.removeAll()
        
        firebaseManager.downloadGroup(groupType: openGroupType) { (groupData) in
            
            self.group.insert(groupData, at: 0)
            self.collectionView.reloadData()
        }
    }
    
    private func setup() {
        
        setColletionView()
        downloadData()
        notiSetup()
        
        SVProgressHUD.dismiss()

    }
    
    private func setColletionView() {
        
        registerTableViewCell(identifier: String(describing: ProductCollectionViewCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        
    }
    
    private func downloadData() {
        
        SVProgressHUD.show()
        
        firebaseManager.downloadGroup(groupType: openGroupType) { (groupData) in
            
            self.group.insert(groupData, at: 0)
                        
            self.collectionView.reloadData()
        }
        
        firebaseManager.detectChildRemove(openGroupType: openGroupType) { (keys) in
            
            for (index, key) in keys.enumerated() {
                
                for value in self.group {
                    
                    guard let id = value.groupId else {
                        break
                    }
                    
                    if key == id {
                        
                        self.group.remove(at: index)
                        break
                    }
                    
                }
                
            }
            self.collectionView.reloadData()
        }

                
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }
    
}

extension ShareBuyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard group.count > 0 else {
            
            collectionView.isHidden = true
            return 0
        }
        
        collectionView.isHidden = false
        
        return group.count

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
        
        cell.updateGroupInfo(
            productUrl: group[indexPath.row].products.first?.productImage ?? "",
            authorUrl: group[indexPath.row].owner?.userImage ?? "",
            title:  group[indexPath.row].article.articleTitle,
            location: group[indexPath.row].article.location,
            postDate:  group[indexPath.row].article.postDate
        )
        
        return cell
    }
    
}

extension ShareBuyViewController: UICollectionViewDelegateFlowLayout {
    
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
