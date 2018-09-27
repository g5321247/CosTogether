//
//  DetailViewController.swift
//  
//
//  Created by George Liu on 2018/9/25.
//

import UIKit
import FSPagerView

class DetailViewController: UIViewController, ProductPicDelegate{
    
    #warning ("TODO: Delete this")
    var testArray: [UIImage] = [#imageLiteral(resourceName: "test"), #imageLiteral(resourceName: "test2")]
    
    private lazy var sections: [CellClass] = [.productPic, .authorInfo, .productItems(testArray.count)]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpCell()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpCell() {
        
        registerTableViewCell(identifier: String(describing: ProductItemTableViewCell.self))
        registerTableViewCell(identifier: String(describing: ProductPicTableViewCell.self))

    }
    
    private func registerTableViewCell(identifier: String) {

        let nibCell = UINib(nibName: identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: identifier)
        
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
        
        return 300
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
            
        case .productPic:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductPicTableViewCell.self)) as? ProductPicTableViewCell else { return UITableViewCell()}
            
            cell.view.delegate = self

            cell.reloadProductPicView()
            
            return cell

        default:
            return UITableViewCell()
        }
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductItemTableViewCell.self)) as? ProductItemTableViewCell else { return UITableViewCell()}
//
        
        
        
//        cell.productImage.image = testArray[indexPath.row]
        
        return UITableViewCell()
    }
    
}
