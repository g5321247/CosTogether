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

struct OwnGroup: DataProtocol {
    
    let groupType: OpenGroupType
    let groupId: String
    let products: [ProductModel]
    var group: Group?
    
    init(
        groupType: OpenGroupType,
        groupId: String,
        products: [ProductModel],
        group: Group? = nil
        ) {
        
        self.groupType = groupType
        self.groupId = groupId
        self.products = products
        self.group = group
    }

}

struct Group: DataProtocol {
    
    let openType: OpenGroupType
    let article: ArticleModel
    let products: [ProductModel]
    let userID: String
    var owner: UserModel?
    var memberID : [String]?
    let groupId: String?
    
    init(
        openType: OpenGroupType,
        article: ArticleModel,
        products: [ProductModel],
        userID: String,
        owner: UserModel? = nil,
        memberID: [String]? = nil,
        groupId: String? = nil
        ) {
        
        self.openType = openType
        self.article = article
        self.products = products
        self.userID = userID
        self.owner = owner
        self.groupId = groupId
        self.memberID = memberID
    }
    
}

struct MainPageViewModel: DataProtocol {
    
    let user: UserModel
    let producet: ProductModel
}

struct ArticleModel: DataProtocol {
    
    let articleTitle: String
    
    let location: String
    
    let postDate: String
    
    let content: String
        
}

struct CommentModel: DataProtocol {
    
    let postDate: String
    let comment: String
    let userId: String
    let user: UserModel?
    
    init(postDate: String, comment: String, userId: String, user: UserModel? = nil ) {
        
        self.postDate = postDate
        self.comment = comment
        self.userId = userId
        self.user = user
        
    }
}

struct UserModel: DataProtocol {
        
    let userImage: String
    
    let userName: String
    
    var numberOfEvaluation: Int?
    
    var buyNumber: Int?
    
    var averageEvaluation: Double?
    
    var userId: String?
    
    init (
        userImage: String,
        userName: String,
        numberOfEvaluation: Int? = 0,
        buyNumber: Int? = 0,
        averageEvaluation: Double? = 0,
        userId: String? = nil
        ) {
        
        self.userImage = userImage
        self.userName = userName
        self.numberOfEvaluation = numberOfEvaluation
        self.buyNumber = buyNumber
        self.averageEvaluation = averageEvaluation
        self.userId = userId
    }
    
    static func groupMember(image: String, name: String) -> UserModel {
        
        return UserModel(
            userImage: image,
            userName: name,
            numberOfEvaluation: nil,
            buyNumber: nil,
            averageEvaluation: nil,
            userId: nil
        )
        
    }
    
}

struct ProductModel: DataProtocol {
    
    var productName: String
    
    var productImage: String?
    
    var numberOfItem: Int
    
    var price: Int
    
    var updateImage: UIImage?
    
    init (
        productName: String,
        productImage: String?,
        numberOfItem: Int,
        price: Int,
        updateImage: UIImage? = nil
        ) {
        
        self.productName = productName
        self.productImage = productImage
        self.numberOfItem = numberOfItem
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
            price: totalCost,
            updateImage: nil
        )
        
    }
    
    static func addNewProduct(
        productName: String,
        productImage: UIImage,
        numberOfItem: Int,
        price: Int) -> ProductModel {
        
        return ProductModel(
            productName: productName,
            productImage: nil,
            numberOfItem: numberOfItem,
            price: price,
            updateImage: productImage
        )

    }
}
