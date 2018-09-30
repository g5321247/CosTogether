//
//  JoinGroupTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/28.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

protocol JoinGroupDelegate: AnyObject {
    
    var members: [String] { get set }
    
    func showTheView(controller: UIViewController)
}

class JoinGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var baseView: UIView!
    
    weak var delegate: JoinGroupDelegate?
    
    #warning ("改 user")
    var users: [Int] = [1,2,3]
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setup() {
        
        setColletionView()
        setupBaseView()
    }
    
    private func setColletionView() {
        
        #warning ("改 cell")
        registerTableViewCell(identifier: String(describing: MemberCollectionViewCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
        
    }
    
    private func registerTableViewCell(identifier: String) {
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: identifier)
        
    }
    
    private func setupBaseView() {
        
        baseView.shadowSetup(cgSize: CGSize(width: 0.5, height: 0.5), shadowRadius: 2, shadowOpacity: 0.2)
        
    }

}

extension JoinGroupTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return delegate?.members.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: MemberCollectionViewCell.self),
            for: indexPath
            ) as? MemberCollectionViewCell else {

                print("No such cell")
                return UICollectionViewCell()

        }

        return cell
    }
}

extension JoinGroupTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 45 / 375.0 * Double(UIScreen.main.bounds.width)
        
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        #warning ("改成 user profile")
        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
                    withIdentifier: String(describing: ProfileViewController.self)
                    ) as? ProfileViewController else {
                        
                        return
        
        }
        
        controller.loadViewIfNeeded()
        controller.userNameLbl.text = delegate?.members[indexPath.row]
        
        delegate?.showTheView(controller: controller)
    }

}
