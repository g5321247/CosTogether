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
    
//    var products: [Product] { get set }
    var testArray: [UIImage] { get set }

}

class ProductPicView: UIView {
    
    weak var delegate: ProductPicDelegate?
    
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    
    var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()
        
    }
    
     func setup() {
        
        setPagerView()
        
        setPageControl()
        
        self.pagerView.bringSubviewToFront(self.pageControl)
        
        setupBackgroundImageView()

    }
    
    private func setupBackgroundImageView() {
        
        self.cornerSetup(cornerRadius: 4,
                         borderWidth: 1,
                         borderColor: UIColor.gray.cgColor,
                         maskToBounds: false)
        
        self.shadowSetup(
        cgSize: CGSize(width: 2, height: 2),
        shadowRadius: 4,
        shadowOpacity: 0.2
        )
        
    }
    
    private func setPagerView() {
        
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        pagerView.isInfinite = true
        
        self.pagerView.transformer = FSPagerViewTransformer(type: .zoomOut)

    }
    
    private func setPageControl() {
        
        #warning ("TODO: numberOfPage 要改成 delegate.products.count")
        self.pageControl.numberOfPages = delegate?.testArray.count ?? 1
        
        pageControl.setFillColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        pageControl.setFillColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 6
        
        pageControl.contentHorizontalAlignment = .center
        
    }
    
}

extension ProductPicView: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        #warning ("TODO: testArray 改成 products ")

        guard let numberOfItem = delegate?.testArray.count else {
            
            return 0
        }
        
        return numberOfItem
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = delegate?.testArray[index]
        
        return cell
    }

}

extension ProductPicView: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
        pageControl.currentPage = index
        
    }
    
}
