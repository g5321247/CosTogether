//
//  ProductPicView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import FSPagerView

protocol ProductPicDelegate: AnyObject {
    
    var products: [Product] { get set }
    
}

class ProductPicView: UIView {

    weak var delegate: ProductPicDelegate?
    
    @IBOutlet weak var pagerView: FSPagerView! {
        
        didSet {
            
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            
            pagerView.isInfinite = false
            
            self.pagerView.transformer = FSPagerViewTransformer(type: .zoomOut)
            self.pagerView.bringSubviewToFront(self.pageControl)

        }
    }
  
    @IBOutlet weak var pageControl: FSPageControl! {
        
        didSet {
            
            #warning ("TODO: numberOfPage 要改成 delegate.products.count")
            
            self.pageControl.numberOfPages = 3
            
            pageControl.setFillColor(#colorLiteral(red: 0.1411764706, green: 0.3215686275, blue: 0.6196078431, alpha: 1), for: .selected)
            pageControl.setFillColor(#colorLiteral(red: 0.9561026692, green: 0.9627470374, blue: 0.9719958901, alpha: 0.85), for: .normal)
            
            pageControl.itemSpacing = 10
            pageControl.interitemSpacing = 6
            
            pageControl.contentHorizontalAlignment = .center

        }
    }
    
    var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()

    }
    
    private func setup() {
        
        setupBackgroundImageView()

    }
    
    private func setupBackgroundImageView() {
        
        self.cornerSetup(cornerRadius: 0,
                         borderWidth: 0.8,
                         borderColor: UIColor.gray.cgColor,
                         maskToBounds: false)
        
        self.shadowSetup(
        cgSize: CGSize(width: 1, height: 1),
        shadowRadius: 2,
        shadowOpacity: 0.2
        )
        
    }
    
}

extension ProductPicView: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        guard let numberOfItem = delegate?.products.count else {
            
            #warning ("TODO: 改成 0")

            return 3
        }
        
        return numberOfItem
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.imageView?.image = #imageLiteral(resourceName: "test")
        
        return cell
    }

}

extension ProductPicView: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
        pageControl.currentPage = index
        
    }
    
}
