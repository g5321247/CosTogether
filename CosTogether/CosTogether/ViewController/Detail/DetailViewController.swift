//
//  DetailViewController.swift
//  
//
//  Created by George Liu on 2018/9/25.
//

import UIKit
import FSPagerView

class DetailViewController: UIViewController {
    
    #warning ("TODO: Delete this")
    var testArray: [UIImage] = [#imageLiteral(resourceName: "test"),#imageLiteral(resourceName: "test2")]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let identifier = String(describing: ProductItemTableViewCell.self)
        
        let nibCell = UINib(nibName: identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: identifier)
        
        #warning ("記得刪除 font 查詢")
//        UIFont.familyNames.forEach({ familyName in
//            let fontNames = UIFont.fontNames(forFamilyName: familyName)
//            print(familyName, fontNames)
//        })
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductItemTableViewCell.self)) as? ProductItemTableViewCell else { return UITableViewCell()}
        
        cell.productImage.image = testArray[indexPath.row]
        
        return cell
        
    }
    
}
