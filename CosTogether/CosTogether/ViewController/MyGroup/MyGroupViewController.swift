//
//  MyGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/1.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class MyGroupViewController: UIViewController {

    @IBOutlet weak var groupTypeSC: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var group: [UIImage] = [#imageLiteral(resourceName: "test")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        navigationController?.navigationBar.isHidden = true
        groupTypeSC.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func switchGroupType(_ sender: Any) {
        
        groupTypeSC.changeUnderlinePosition()
        
    }
    
    private func setup() {
        
        setUpCell()
        tableViewSetup()
        
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

    @objc func evaluateUser(_ sender: UIButton) {
        
        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self))
            as? ProfileViewController else {
                
                return
        }
        
        controller.loadViewIfNeeded()
        
        controller.userType = .otherUser
        controller.evaluateButton.isHidden = false
        controller.evaluateButton.isEnabled = true
        
        show(controller, sender: nil)
    }

}

extension MyGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let controller = UIStoryboard.mainStoryboard().instantiateViewController(
            withIdentifier: String(describing: DetailViewController.self))
            as? DetailViewController else {
            
            return
        }
        
        show(controller, sender: nil)
    }
    
}

extension MyGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GroupTableViewCell.self)
            ) as? GroupTableViewCell else {
                
                return UITableViewCell()
                
        }
        
        cell.baseView.authorImageBot.addTarget(self, action: #selector (evaluateUser(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none

        return cell
        
    }
    
}
