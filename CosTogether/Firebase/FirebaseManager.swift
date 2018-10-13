//
//  FirebaseManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import Firebase
import KeychainAccess
import NotificationBannerSwift

struct UserInfo {
    
    var userName: String
    var userPicUrl: String

}

enum FirebaseType: String {
    
    case uuid
    
}

struct FirebaseManager {
    
    func logInFirebase(
        token: String,
        sucess: @escaping (UserInfo) -> Void,
        faliure: @escaping (Error) -> Void
        ) {
        
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
            Auth.auth().signInAndRetrieveData(
            with: credential) { (authResult, error) in
            
                guard error == nil else {
                    
                    faliure(FirebaseError.system(error!.localizedDescription))
                    
                    return
                    
                }
                
                guard let firebaseResult = authResult else {
                    
                    faliure(FirebaseError.unrecognized("No Firebase Data"))
                    
                    return
                    
                }
                
                let user = firebaseResult.user
                let userInfo = UserInfo(userName: user.displayName!, userPicUrl: user.photoURL!.absoluteString)
                
                let refrence = Database.database().reference()
                
                refrence.child("users").child(user.uid).child("userInfo").setValue(
                    [
                    "userName": userInfo.userName,
                    "userPicUrl" : userInfo.userPicUrl
                    ]
                )
                
                let keychain = Keychain(service: "com.george.CosTogether")
                keychain[FirebaseType.uuid.rawValue] = user.uid
                
                sucess(userInfo)
                
        }
    }
    
    func uploadProductPics(
        articleTitle: String,
        productName: String,
        picture: Data,
        sucess: @escaping (URL) -> Void,
        faliure: @escaping (Error) -> Void
        ) {

        guard  let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let storageRef =  Storage.storage().reference().child("group").child(userId).child(articleTitle).child(productName)
        
        storageRef.putData(picture, metadata: nil) { (data, error) in
            
            guard error == nil else {

                faliure((FirebaseError.system(error!.localizedDescription)))
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                
                guard error == nil else {
                    
                    faliure((FirebaseError.system(error!.localizedDescription)))
                    return
                }

                guard let url = url else {
                    
                    faliure((FirebaseError.uploadPicFail("上傳照片失敗")))
                    return
                }
                
                sucess(url)
                
            })
            
        }
        
    }
    
    func uploadGroup(group: Group) {
        
        let refrence = Database.database().reference()
        
        guard let key = refrence.child("group").child(group.openType.rawValue).childByAutoId().key else {
            
            #warning ("上傳失敗警告")
            
            return
        }
        
        uploadArticle(refrence: refrence, key: key, group: group)
        uploadProduct(refrence: refrence, key: key, group: group)
        uploadUser(refrence: refrence, key: key, group: group)
    }
    
    func downloadGroup(groupType: OpenGroupType, completion: @escaping (Group) -> Void) {
        
        let refrence = Database.database().reference()
        
        refrence.child("group").child(groupType.rawValue).observe(.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let groupId = snapshot.key
            
            guard let article = value?["article"] as? NSDictionary,
            let location = article["location"] as? String,
            let postDate = article["postDate"] as? String,
                let title = article["title"] as? String else {
                    
                    return
        
            }
            
            let articleModel = ArticleModel(articleTitle: title, location: location,postDate: postDate)
            
            guard let products = value?["products"] as? NSDictionary,
                let productName = products.allKeys as? [String] else {
                    
                    
                    return
            }
            
            var productsArray: [ProductModel] = []
            
            for value in productName {
                
                guard let product = products[value] as? NSDictionary,
                let imageUrl = product["imageUrl"] as? String,
                let numberOfItem = product["numberOfItem"] as? Int,
                    let price = product["price"] as? Int else {
                        
                        return
                }
                
                productsArray.append(
                    ProductModel(
                        productName: value,
                        productImage: imageUrl,
                        numberOfItem: numberOfItem,
                        price: price
                    )
                )
                
            }

            #warning ("使用者 id 和加團者 id")
            
            guard let users = value?["users"] as? NSDictionary,
                let ownerId = users["ownerId"] as? String else {
                    
                    return
            }
            
            self.userIdToGetUserInfo(refrence: refrence, userId: ownerId, completion: { (userModel) in
                
                let group = Group(
                    openType: groupType,
                    article: articleModel,
                    products: productsArray,
                    userID: ownerId,
                    owner: userModel,
                    groupId: groupId
                )
                
                completion(group)
                
            })

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func downloadGroupUser(group: Group, completion: @escaping ([String]) -> Void) {
        
        let refrence = Database.database().reference()
    refrence.child("group").child(group.openType.rawValue).child(group.groupId!).child("users").observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
        
            guard let memberIds = value?.allKeys as? [String] else {
            
                return
            }
        
            completion(memberIds)
        }
    }
    
}

extension FirebaseManager {
    
    private func uploadArticle(refrence: DatabaseReference, key: String, group: Group) {
        
        refrence.child("group").child("\(group.openType.rawValue)").child("\(key)").child("article").setValue(
            
            [
                "title": group.article.articleTitle,
                "location" : group.article.location,
                "postDate": group.article.postDate
            ]
            
        )
    }
    
    private func uploadProduct(refrence: DatabaseReference, key: String, group: Group) {
        
        for value in group.products {
            
            refrence.child("group").child("\(group.openType.rawValue)").child("\(key)").child("products").child(value.productName).setValue(
                
                [
                    "numberOfItem": value.numberOfItem,
                    "price" : value.price,
                    "imageUrl": value.productImage ?? ""
                ]
                
            )
            
        }
        
    }
    
    private func uploadUser(refrence: DatabaseReference, key: String, group: Group) {
        
        guard  let userId = Auth.auth().currentUser?.uid else {
            return
        }

        refrence.child("group").child(group.openType.rawValue).child(key).child("users").setValue(
            [
                "ownerId": group.userID,
            ]
        )
        
        refrence.child("users").child(userId).child("userInfo").child("myGroup").child("own").setValue(
            [
                key: key
            ]
        )

    }
    
    #warning ("用使用者 id 拿資料")
    func userIdToGetUserInfo(
        refrence: DatabaseReference = Database.database().reference()
        , userId: String,
          completion: @escaping (UserModel) -> Void
        ) {
        
        refrence.child("users").child(userId).observeSingleEvent(of: .childAdded) { (snapshot) in
           
            let value = snapshot.value as? NSDictionary
            
            guard let userPicUrl = value?["userPicUrl"] as? String,
                let userName = value?["userName"] as? String else {
                    
                    return
                    
            }
            
            #warning ("增加評價內容,內容如下")

//            if avreage != "" {
//
//                avreage = 0
//            } else {
//                get data
//            }
            
            completion(UserModel(userImage: userPicUrl, userName: userName))
            
        }
    }
    
    func uploadBuyer(buyerId: String, groupType: OpenGroupType ,groupId: String, product: ProductModel, buyNumber: Int) {
        
        let refrence = Database.database().reference()
        
        let childUpdates = [
            "/group/\(groupType.rawValue)/\(groupId)/products/\(product.productName)/numberOfItem": product.numberOfItem,
            "/group/\(groupType.rawValue)/\(groupId)/users/buyerId/\(buyerId)": buyerId,
            "/users/\(buyerId)/userInfo/myGroup/join/\(groupId)/\(product.productName)": [
                "numberOfItem": buyNumber
            ]
        ] as [String : Any]
        
        refrence.updateChildValues(childUpdates)
        
    }
    
}
