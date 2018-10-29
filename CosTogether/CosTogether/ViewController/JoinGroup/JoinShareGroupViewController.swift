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

class JoinShareGroupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    let firebaseManager = FirebaseManager()
    
    var groupType: OpenGroupType = .shareBuy
    
    var myGroup: MyGroup = .join
    
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
        
        self.tableView.addSubview(animationView)
        
        animationView.play()
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            return
        }
        
        firebaseManager.downloadMyGroup(groupType: groupType, myGroup: myGroup) { (group) in
            
            self.firebaseManager.getGroupInfo(ownGroup: group, completion: { (group) in
                
                self.myGroups.append(group)
                
                self.emptyLbl.isHidden = true
                self.animationView.isHidden = true
                
                self.reloadData()

            })
            
        }
        
        firebaseManager.detectChildRemove(openGroupType: groupType) { (keys) in
            
            for (index, key) in keys.enumerated() {
                
                for value in self.myGroups {
                    
                    if key == value.groupId {
                        
                        self.myGroups.remove(at: index)
                        break
                    }
                    
                }
                
            }
            self.reloadData()
        }
        
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: String(describing: GroupTableViewCell.self))
            ])
        
    }
    
    private func reloadData() {
        
        guard myGroups.count > 0 else {
            
            tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)

            return
        }
        
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        tableView.reloadData()
        
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension JoinShareGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 310

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
    
}

extension JoinShareGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GroupTableViewCell.self), for: indexPath
            ) as? GroupTableViewCell else {
                
                return UITableViewCell()
                
        }
        
        cell.updateGroupHistory(ownGroup: myGroups[indexPath.row])
        
        cell.selectionStyle = .none

        return cell
        
    }
    
}
