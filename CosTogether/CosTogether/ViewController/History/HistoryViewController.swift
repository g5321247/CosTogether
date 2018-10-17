//
//  HistoryViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: TopLogoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        tableViewSetup()
        setUpCell()
        topLogViewSetup()
    }
    
    private func topLogViewSetup() {
        
        topView.leftBot.addTarget(self, action: #selector(backBotTapping(_:)), for: .touchUpInside)
    }

    @objc func backBotTapping(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: UserCalculateTableViewCell.self)
            ])
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadData() {
        
        tableView.reloadData()
    }
    
    
    lazy var allData: [DataType] = []
    


    
    
}

extension HistoryViewController: UITableViewDelegate {
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserCalculateTableViewCell.self)) as? UserCalculateTableViewCell else {
            
            return UITableViewCell()
        }
        
        return cell
    }
    


}
