//
//  ChatRoomViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/30.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    @IBOutlet weak var topLogView: TopLogoView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: MessageView!
    
    var chats: [String] = ["臣亮言：先帝創業未半，而中道崩殂。今天下三分，益州 疲弊，此誠危急存亡之秋也。然侍衛之臣，不懈於內；忠志之 士，忘身於外者，蓋追先帝之殊遇，欲報之於陛下也。誠宜開 張聖聽，以光先帝遺德，恢弘志士之氣"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
 
    private func setup() {
        
        setUpCell()
        tableViewSetup()
        topLogViewSetup()
        
    }
    
    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: String(describing: OhterMessageTableViewCell.self))
            ])
        
    }
    
    private func topLogViewSetup() {
        
        topLogView.leftBot.addTarget(self, action: #selector(backBotTapping(_:)), for: .touchUpInside)
      
    }
    
    @objc func backBotTapping(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
    }
}

extension ChatRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ChatRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: OhterMessageTableViewCell.self)
            ) as? OhterMessageTableViewCell else {
                
                return UITableViewCell()
                
        }
        
//        cell.commentLbl.text = chats[indexPath.row]
        
        return cell
        
    }
    
}
