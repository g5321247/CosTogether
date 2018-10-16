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
                
                refrence.child("users").child(user.uid).child("userInfo").child("userName").setValue(userInfo.userName)
                refrence.child("users").child(user.uid).child("userInfo").child("userPicUrl").setValue(userInfo.userPicUrl)
                
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
                let title = article["title"] as? String,
                let content = article["content"] as? String else {
                    
                    return
        
            }
            
            let articleModel = ArticleModel(
                articleTitle: title,
                location: location,
                postDate: postDate,
                content: content
                )
            
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
    
    func downloadCommentUser(group: Group, completion: @escaping (CommentModel) -> Void) {

        let refrence = Database.database().reference()
    refrence.child("group").child(group.openType.rawValue).child(group.groupId!).child("comment").observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
        
            guard let postDate = value?["postDate"] as? String,
                let comment = value?["comment"] as? String,
                let userId = value?["userId"] as? String else {
            
                return
            }
        
            self.userIdToGetUserInfo(userId: userId, completion: { (userModel) in
               
                let aComment = CommentModel(postDate: postDate, comment: comment, userId: userId, user: userModel)
                
                completion(aComment)

            })
        
        }
        
    }
    
    func downloadMyGroup(groupType: OpenGroupType, myGroup: MyGroup, completion: @escaping (OwnGroup) -> Void) {
        
        let refrence = Database.database().reference()
        refrence.child("users").child(Auth.auth().currentUser!.uid).child("userInfo").child("myGroup").child(myGroup.rawValue).child(groupType.rawValue).observe(.childAdded) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                
                return
            }
            
            guard let productsName = value.allKeys as? [String] else {
                return
            }
            
            var products: [ProductModel] = []

            for key in productsName {
                
                guard let productDic = value[key] as? NSDictionary,
                    let  numberOfItem = productDic["numberOfItem"] as? Int,
                    let price =  productDic["price"] as? Int,
                    let productImage = productDic["productPicUrl"] as? String else {

                    return
                }
                
                let product = ProductModel(
                    productName: key,
                    productImage: productImage,
                    numberOfItem: numberOfItem,
                    price: price
                )
                
                products.append(product)
            }
            
            let ownGroup = OwnGroup(groupType: groupType, groupId: snapshot.key, products: products)
            
            completion(ownGroup)
        }
    }

    
}

extension FirebaseManager {
    
    private func uploadArticle(refrence: DatabaseReference, key: String, group: Group) {
        
        refrence.child("group").child("\(group.openType.rawValue)").child("\(key)").child("article").setValue(
            
            [
                "title": group.article.articleTitle,
                "location" : group.article.location,
                "postDate": group.article.postDate,
                "content" : group.article.content
            ]
            
        )
    }
    
    private func uploadProduct(refrence: DatabaseReference, key: String, group: Group) {
        
        for value in group.products {
            
            refrence.child("group").child("\(group.openType.rawValue)").child("\(key)").child("products").child(value.productName).setValue(
                
                [
                    "numberOfItem": value.numberOfItem,
                    "price" : value.price,
                    "imageUrl": value.productImage ?? "",
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
        
        refrence.child("users").child(userId).child("userInfo").child("myGroup").child("own").child(group.openType.rawValue).updateChildValues(
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
            "/users/\(buyerId)/userInfo/myGroup/join/\(groupType.rawValue)/\(groupId)/\(product.productName)": [
                "numberOfItem": buyNumber,
                "price": product.price,
                "productPicUrl": product.productImage!
            ]
        ] as [String : Any]
        
        refrence.updateChildValues(childUpdates)
        
    }
    
    func uploadComment(comment: CommentModel, groupType: OpenGroupType ,groupId: String) {
        
        let refrence = Database.database().reference()
        
        guard let key = refrence.child("group").child(groupType.rawValue).child(groupId).child("comment").childByAutoId().key else {

            return
        }
        
        let post = [
            "userId" : comment.userId,
            "comment": comment.comment,
            "postDate": comment.postDate
            ] as [String : String]
        
        let childUpdates = [
            "/group/\(groupType.rawValue)/\(groupId)/comment/\(key)": post
        ]
        
        refrence.updateChildValues(childUpdates)
        
    }
    
    func getGroupInfo(ownGroup: OwnGroup, completion: @escaping (OwnGroup) -> Void) {
        
        let refrence = Database.database().reference()
        refrence.child("group").child(ownGroup.groupType.rawValue).child(ownGroup.groupId).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            guard let article = value?["article"] as? NSDictionary,
                let location = article["location"] as? String,
                let postDate = article["postDate"] as? String,
                let title = article["title"] as? String,
                let content = article["content"] as? String else {
                    
                    return
                    
            }
            
            let articleModel = ArticleModel(
                articleTitle: title,
                location: location,
                postDate: postDate,
                content: content
            )
            
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

            guard let users = value?["users"] as? NSDictionary,
                let ownerId = users["ownerId"] as? String else {
                    
                    return
            }
            
            self.userIdToGetUserInfo(refrence: refrence, userId: ownerId, completion: { (userModel) in
                
                let group = Group(
                    openType: ownGroup.groupType,
                    article: articleModel,
                    products: productsArray,
                    userID: ownerId,
                    owner: userModel,
                    groupId: ownGroup.groupId
                )
                
                let own = OwnGroup(
                    groupType: ownGroup.groupType,
                    groupId: ownGroup.groupId,
                    products: ownGroup.products,
                    group: group
                )
                
                completion(own)
                
            })

        
        }
    }
    
    func downloadMyOwnGroup(groupType: OpenGroupType, myGroup: MyGroup, completion: @escaping (OwnGroup) -> Void) {
        
        let refrence = Database.database().reference()
        refrence.child("users").child(Auth.auth().currentUser!.uid).child("userInfo").child("myGroup").child(myGroup.rawValue).child(groupType.rawValue).observe(.childAdded) { (snapshot) in
            
            guard let groupId = snapshot.value as? String else {
                
                return
            }
            
            self.getOpenGroupInfo(groupType: groupType, groupId: groupId, completion: { (ownGroup) in
                completion(ownGroup)
            })
        }
            
    }
    
    func getOpenGroupInfo(groupType: OpenGroupType, groupId: String, completion: @escaping (OwnGroup) -> Void) {
        
        let refrence = Database.database().reference()
        refrence.child("group").child(groupType.rawValue).child(groupId).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            guard let article = value?["article"] as? NSDictionary,
                let location = article["location"] as? String,
                let postDate = article["postDate"] as? String,
                let title = article["title"] as? String,
                let content = article["content"] as? String else {
                    
                    return
                    
            }
            
            let articleModel = ArticleModel(
                articleTitle: title,
                location: location,
                postDate: postDate,
                content: content
            )
            
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
            
            guard let users = value?["users"] as? NSDictionary,
                let ownerId = users["ownerId"] as? String else {
                    
                    return
            }
            
            self.userIdToGetUserInfo(refrence: refrence, userId: ownerId, completion: { (userModel) in
                
                let group = Group(
                    openType: groupType,
                    article: articleModel,
                    products: productsArray,
                    userID: Auth.auth().currentUser!.uid,
                    owner: userModel,
                    groupId: groupId
                )

                let own = OwnGroup(
                    groupType: groupType,
                    groupId: groupId,
                    products: productsArray,
                    group: group
                )
                
                completion(own)
                
            })
            
            
        }
    }
    
}
