//
//  ChatViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/30.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var topLogoView: TopLogoView!
    @IBOutlet weak var tableView: UITableView!
    
    var chats: [String] = ["臣亮言：先帝創業未半，而中道崩殂。今天下三分，益州 疲弊，此誠危急存亡之秋也。然侍衛之臣，不懈於內；忠志之 士，忘身於外者，蓋追先帝之殊遇，欲報之於陛下也。誠宜開 張聖聽，以光先帝遺德，恢弘志士之氣"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }
    
    private func setup() {
        
        setUpCell()
        tableViewSetup()
    }

    private func setUpCell() {
        
        tableView.registerTableViewCell(identifiers: [
            String(describing: String(describing: PreviousCommentTableViewCell.self))
            ])
        
    }
    
    private func tableViewSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let controller =
            UIStoryboard.chatRoomStoryboard().instantiateViewController(withIdentifier:
                String(describing: ChatRoomViewController.self)
                )
                as? ChatRoomViewController else {
            return
        }
        
        show(controller, sender: nil)
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PreviousCommentTableViewCell.self)
            ) as? PreviousCommentTableViewCell else {
                
                return UITableViewCell()
                
        }
        
        cell.commentLbl.text = chats[indexPath.row]
        
        return cell

    }
    
}
