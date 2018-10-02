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
    
    let user: UserModel

}

struct CommentModel: DataProtocol {
    
    let postDate: Date
    
    let user: UserModel
    
}

struct UserModel: DataProtocol {
    
    let userImage: String
    
    let userName: String
    
    let numberOfEvaluation: Int
    
    let buyNumber: Int
    
    let averageEvaluation: Double
    
}

struct ProductModel: DataProtocol {
    
    var productName: String
    
    var productImage: String
    
    var numberOfItem: String
    
    var expiredDate: Date
    
    var price: String

}

struct DescriptionModel: DataProtocol {
    
    var description: String
    
}
