//
//  UserDataModel.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/30.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

struct DataType {
    
    var dataType: CellClass
    
    var data: [DataProtocol]
    
}

protocol DataProtocol {
    
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
    
    var openType: OpenGroupType
    
    static func purchasingProduct(
        name: String,
        number: Int,
        totalCost: Int,
        openType: OpenGroupType) -> ProductModel {
        
        return ProductModel(
            productName: name,
            productImage: nil,
            numberOfItem: number,
            expiredDate: nil,
            price: totalCost,
            openType: openType
        )
        
    }
    
}

struct DescriptionModel: DataProtocol {
    
    var description: String
    
}
