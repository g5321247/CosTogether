//
//  UserDataModel.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/30.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

struct DataType {
    
    var dataType: CellClass
    
    var data: [DataProtocol]
    
}

protocol DataProtocol {
    
}

struct GroupType: DataProtocol {
    
    let openType: OpenGroupType
    let products: [ProductModel]
    
}

struct MainPageViewModel: DataProtocol {
    
    let user: UserModel
    let producet: ProductModel
}

struct ArticleModel: DataProtocol {
    
    let articleTitle: String
    
    let location: String
    
    let postDate: Date
    
    let productTag: String
    
    let user: UserModel

}

struct CommentModel: DataProtocol {
    
    let postDate: Date
    let user: UserModel
    let comment: String

}

struct UserModel: DataProtocol {
    
    #warning ("uuid 記得加")
//    let uuid:
    
    let userImage: String
    
    let userName: String
    
    var numberOfEvaluation: Int?
    
    var buyNumber: Int?
    
    var averageEvaluation: Double?
    
    static func groupMember(image: String, name: String) -> UserModel {
        
        return UserModel(
            userImage: image,
            userName: name,
            numberOfEvaluation: nil,
            buyNumber: nil,
            averageEvaluation: nil
        )
        
    }
    
}

struct ProductModel: DataProtocol {
    
    var productName: String
    
    var productImage: String?
    
    var numberOfItem: Int
    
    var expiredDate: Date?
    
    var price: Int
    
    var updateImage: UIImage?
    
    init (
        productName: String,
        productImage: String?,
        numberOfItem: Int,
        expiredDate: Date?,
        price: Int,
        updateImage: UIImage?
        ) {
        
        self.productName = productName
        self.productImage = productImage
        self.numberOfItem = numberOfItem
        self.expiredDate = expiredDate
        self.price = price
        self.updateImage = updateImage
    }
    
    static func purchasingProduct(
        name: String,
        number: Int,
        totalCost: Int
        ) -> ProductModel {
        
        return ProductModel(
            productName: name,
            productImage: nil,
            numberOfItem: number,
            expiredDate: nil,
            price: totalCost,
            updateImage: nil
        )
        
    }
    
    static func addNewProduct(
        productName: String,
        productImage: UIImage,
        numberOfItem: Int,
        expiredDate: Date?,
        price: Int) -> ProductModel {
        
        return ProductModel(
            productName: productName,
            productImage: nil,
            numberOfItem: numberOfItem,
            expiredDate: expiredDate ?? nil,
            price: price,
            updateImage: productImage
        )

    }
}

struct DescriptionModel: DataProtocol {
    
    var description: String
    
}
