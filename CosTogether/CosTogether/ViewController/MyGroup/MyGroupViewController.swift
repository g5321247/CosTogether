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

}

extension MyGroupViewController: UITableViewDelegate {
    
    
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
        
//        cell.messageLbl.text = chats[indexPath.row]
                
        return cell
        
    }
    
}
