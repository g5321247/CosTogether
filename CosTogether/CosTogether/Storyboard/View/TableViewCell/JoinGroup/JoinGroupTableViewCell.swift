//
//  JoinGroupTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/28.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Firebase

protocol JoinGroupDelegate: AnyObject {
    
    var joinMember: [UserModel] { get set }
    
    func showTheView(controller: UIViewController)
}

class JoinGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var noMemberJoinLbl: UILabel!
    
    weak var delegate: JoinGroupDelegate?
    
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
    
    func checkoutUserNumber() {
        
        guard let delegate = delegate,
            delegate.joinMember.count > 0 else {
            
            noMemberJoinLbl.isHidden = false
            return
        }
        
        noMemberJoinLbl.isHidden = true

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
        
        return delegate?.joinMember.count ?? 0
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
        
        guard let memberUrl = delegate?.joinMember[indexPath.row].userImage else {
            
            cell.memberImage.image = #imageLiteral(resourceName: "profile_sticker_placeholder02")
            return cell
        }
        
        let url = URL(string: memberUrl)
        
        cell.memberImage.sd_setImage(with: url)
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
        
        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
                    withIdentifier: String(describing: ProfileViewController.self)
                    ) as? ProfileViewController else {
                        
                        return
        
        }
        
        guard let delegate = delegate else {
            
            return
        }
        
        controller.loadViewIfNeeded()
        
        controller.checkOtherUser(
            averageEvaluation: (delegate.joinMember[indexPath.row].averageEvaluation ?? 0),
            userImage: delegate.joinMember[indexPath.row].userImage,
            buyNumber: delegate.joinMember[indexPath.row].buyNumber ?? 0,
            userName: delegate.joinMember[indexPath.row].userName,
            numberOfEvaluation: delegate.joinMember[indexPath.row].numberOfEvaluation ?? 0,
            userType: .otherUser
        )
        
        delegate.showTheView(controller: controller)
    }

}
