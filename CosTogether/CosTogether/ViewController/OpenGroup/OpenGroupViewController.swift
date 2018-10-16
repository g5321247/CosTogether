//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class OpenGroupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        return .lightContent
    }
    
    private func setup() {
        
        setTableView()
    }
    
    
    
    private func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpCell()
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: OepnGroupTableViewCell.self)
            ])
        
    }

    
}

extension OpenGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.size.width / 375 * 667
    }
    
}

extension OpenGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OepnGroupTableViewCell.self)) as? OepnGroupTableViewCell else {
            
            return UITableViewCell()
        }
        
        return cell
    }
    
}
