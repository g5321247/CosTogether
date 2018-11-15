//
//  BaseHistoryViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/11/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Lottie
import SDWebImage

protocol GroupDownloading where Self: BaseHistoryViewController {}

protocol JoinGroupDownloading: GroupDownloading {}

extension JoinGroupDownloading {
    
    func downloadGroupList() {
        
        guard UserManager.shared.userInfo() != nil else {
            
            return
        }
        
        firebaseManager.downloadMyGroup(groupType: groupType, myGroup: myGroup) { [weak self] (group) in
            
            guard let self = self else {
                return
            }
            
            self.firebaseManager.getGroupInfo(ownGroup: group, completion: { [weak self] (group) in
                
                guard let self = self else {
                    return
                }
                
                self.myGroups.append(group)
                
                self.emptyLbl.isHidden = true
                self.animationView.isHidden = true
                
                self.emptyViewIsHidden(isHidden: true)
                
                self.reloadData()
                
            })
            
        }
        
        firebaseManager.detectChildRemove(openGroupType: groupType) { [weak self] (keys) in
            
            guard let self = self else {
                return
            }
            
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
}

protocol OwnGroupDownloading: GroupDownloading {}

extension OwnGroupDownloading {
    
    func downloadGroupList() {
    
    guard UserManager.shared.userInfo() != nil else {
        return
    }
    
    firebaseManager.downloadMyOwnGroup(groupType: groupType, myGroup: myGroup) { [weak self] (group) in
    
        guard let self = self else {
            return
        }
        
        self.firebaseManager.getGroupInfo(ownGroup: group, completion: { [weak self] (group) in
    
            guard let self = self else {
                return
            }
            
            self.myGroups.append(group)
        
            self.emptyLbl.isHidden = true
            self.animationView.isHidden = true
        
            self.emptyViewIsHidden(isHidden: true)
        
            self.reloadData()
        
            })
        }
    }
}

extension OwnGroupDownloading {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            firebaseManager.deleteValue(group: myGroups[indexPath.row].group!)
            
            myGroups.remove(at: indexPath.row)
            
            NotificationCenter.default.post(name: .createNewGroup, object: nil, userInfo: nil)
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
    }
}

class BaseHistoryViewController: UIViewController, GroupDownloading {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    let firebaseManager = FirebaseManager.shared
    
    var groupType: OpenGroupType = .helpBuy
    
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
        emptyViewIsHidden(isHidden: false)
        
    }
    
    internal func emptyViewIsHidden(isHidden: Bool) {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        animationView.center.x = self.view.center.x
        animationView.center.y = self.view.center.y + 40
        
        animationView.contentMode = .scaleAspectFill
        
        self.tableView.addSubview(animationView)
        
        self.emptyLbl.isHidden = isHidden
        self.animationView.isHidden = isHidden
        
        guard !isHidden else {
            return
        }
        
        animationView.play()

    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: String(describing: GroupTableViewCell.self))
            ])
        
    }
    
    internal func reloadData() {
        
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

extension BaseHistoryViewController: UITableViewDelegate {
    
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
}

extension BaseHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell: GroupTableViewCell = UITableViewCell.createCell(tableView: tableView, indexPath: indexPath)
        
        cell.updateGroupHistory(ownGroup: myGroups[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
        
    }
}

