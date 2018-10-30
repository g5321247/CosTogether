//
//  MyGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import SDWebImage

class OwnShareBuyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    let firebaseManager = FirebaseManager()
    
    var groupType: OpenGroupType = .shareBuy
    
    var myGroup: MyGroup = .own
    
    var myGroups: [OwnGroup] = []
    
    let animationView = LOTAnimationView(name: "get_started_slider")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    
    }
    
    private func setup() {
        
        setUpCell()
        tableViewSetup()
        downloadMyGroup()
    }
    
    private func downloadMyGroup() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        animationView.center.x = self.view.center.x
        animationView.center.y = self.view.center.y + 40
        
        animationView.contentMode = .scaleAspectFill
        
        self.emptyLbl.isHidden = false
        self.animationView.isHidden = false
        
        self.tableView.addSubview(animationView)
        
        animationView.play()
        
        guard Auth.auth().currentUser?.uid != nil else {
                        
            return
        }
        
        firebaseManager.downloadMyOwnGroup(groupType: groupType, myGroup: myGroup) { (group) in
            
            self.firebaseManager.getGroupInfo(ownGroup: group, completion: { (group) in
                
                self.myGroups.append(group)
                
                self.emptyLbl.isHidden = true
                self.animationView.isHidden = true
                
                self.reloadData()
                
            })
            
        }
        
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: String(describing: GroupTableViewCell.self))
            ])
        
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func reloadData() {
        
        guard myGroups.count > 0 else {
            
            tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
            
            return
        }
        
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        tableView.reloadData()
        
    }

    @objc func evaluateUser(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.profile().instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self))
            as? ProfileViewController else {
                
                return
        }
        
        controller.loadViewIfNeeded()
        
        controller.userType = .otherUser
       
        show(controller, sender: nil)
    }
    
}

extension OwnShareBuyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.width / 16 * 9 + 50

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        guard let controller = UIStoryboard.detailStoryboard().instantiateViewController(
            withIdentifier: String(describing: DetailViewController.self)
            ) as? DetailViewController else {
                
                return
                
        }
        
        controller.loadViewIfNeeded()
        
        guard let group = myGroups[indexPath.row].group else {
            return
        }
        
        controller.updateInfo(group: group)
        
        show(controller, sender: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            firebaseManager.deleteValue(group: myGroups[indexPath.row].group!)
            
            myGroups.remove(at: indexPath.row)
            
            NotificationCenter.default.post(name: .createNewGroup, object: nil, userInfo: nil)

            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
        
    }
    
}

extension OwnShareBuyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GroupTableViewCell.self)
            ) as? GroupTableViewCell else {
                
                return UITableViewCell()
                
        }
        
        cell.updateGroupHistory(ownGroup: myGroups[indexPath.row])
        
//        cell.baseView.authorImageBot.isHidden = true
        
        cell.selectionStyle = .none
        
        
        return cell
        
    }
    
}
