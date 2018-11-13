//
//  GroupViewModel.swift
//  CosTogether
//
//  Created by George Liu on 2018/11/13.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

struct GroupManager: GroupManagerProtocol {
    
    var openType: OpenGroupType?
    var article: ArticleModel
    var products: [ProductModel]
    var owner: UserModel?
    var memberID : [String]?
    var groupId: String?
    
    static func initWith(group: Group) -> GroupManager {
        
        let model = GroupManager(
            openType: group.openType,
            article: group.article,
            products: group.products,
            owner: group.owner,
            memberID: group.memberID,
            groupId: group.groupId
        )
        
        return model
    }
}
