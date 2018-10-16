//
//  OpenGroupViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class OpenGroupViewController: UIViewController {

    @IBOutlet weak var groupTypeSC: UISegmentedControl!
    @IBOutlet weak var shareBuyView: UIView!
    @IBOutlet weak var helpBuyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTypeSC.addUnderlineForSelectedSegment()
        
        shareBuyView.isHidden = false
        helpBuyView.isHidden = true
        
        setup()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        return .lightContent
    }
    
    private func setup() {
        
        navigationBarSetup()
//        setTableView()
    }
    
    @IBAction func switchGroupType(_ sender: Any) {
        
        groupTypeSC.changeUnderlinePosition()
        
        switch groupTypeSC.selectedSegmentIndex {
            
        case 0:
            
            shareBuyView.isHidden = false
            helpBuyView.isHidden = true
            
        case 1:
            
            shareBuyView.isHidden = true
            helpBuyView.isHidden = false
            
        default:
            break
        }
        
        
    }

    private func navigationBarSetup() {
        
        let  image = UIImage()
        
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = image
    }


//    private func setTableView() {
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        setUpCell()
//    }
//
//    private func setUpCell() {
//
//        tableView.registerTableViewCell(identifiers: [
//            String(describing: OepnGroupTableViewCell.self)
//            ])
//
//    }

    
}

//extension OpenGroupViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return self.view.frame.size.width / 375 * 667
//    }
//
//}
//
//extension OpenGroupViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OepnGroupTableViewCell.self)) as? OepnGroupTableViewCell else {
//
//            return UITableViewCell()
//        }
//
//        return cell
//    }
//
//}
