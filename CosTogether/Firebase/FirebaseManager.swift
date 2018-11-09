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

enum FirebaseType: String {
    
    case uuid
    
}

class FirebaseManager {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    let user = UserManager.shared
    
    func logInFirebase(
        token: String,
        sucess: @escaping () -> Void,
        faliure: @escaping (Error) -> Void
        ) {
        
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
            Auth.auth().signInAndRetrieveData(
            with: credential) { (authResult, error) in
            
                guard error == nil else {
                    
                    faliure(FirebaseError.system(error!.localizedDescription))
                    
                    return
                    
                }
                
                guard authResult != nil else {
                    
                    faliure(FirebaseError.unrecognized("No Firebase Data"))
                    
                    return
                    
                }
           
                guard let userInfo = self.user.userInfo() else {
                    return
                }
                
                let refrence = Database.database().reference()
                
                let keychain = Keychain(service: "com.george.CosTogether")
                keychain[FirebaseType.uuid.rawValue] = userInfo.userId
            refrence.child("users").child(userInfo.userId).child("userInfo").child("userName").setValue(userInfo.userName)
            refrence.child("users").child(userInfo.userId).child("userInfo").child("userPicUrl").setValue(userInfo.userPicURL)
                
                sucess()
                
        }
    }
    
    func uploadProductPics(
        articleTitle: String,
        productName: String,
        picture: Data,
        sucess: @escaping (URL) -> Void,
        faliure: @escaping (Error) -> Void
        ) {

            guard let userInfo = self.user.userInfo() else {
                return
            }

            let storageRef =  Storage.storage().reference().child("group").child(userInfo.userId).child(articleTitle).child(productName)
        
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
    
    func uploadGroup(refrence: DatabaseReference, group: Group, key: String) {
        
        uploadArticle(refrence: refrence, key: key, group: group)
        uploadProduct(refrence: refrence, key: key, group: group)
        uploadUser(refrence: refrence, key: key, group: group)
    }
    
    func downloadGroup(groupType: OpenGroupType, completion: @escaping (Group) -> Void) {
        
        let refrence = Database.database().reference()
        
        refrence.child("group").child(groupType.rawValue).observe(.childAdded, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                
                return
            }
            
            let groupId = snapshot.key
            
            do {

                let articleData = try JSONSerialization.data(withJSONObject: value["article"] as Any)
                
                let article = try self.decoder.decode(ArticleModel.self, from: articleData)
                
                guard let products = value["products"] as? NSDictionary,
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
                
                guard let users = value["users"] as? NSDictionary,
                    let ownerId = users["ownerId"] as? String else {
                        
                        return
                }
                
                self.userIdToGetUserInfo(refrence: refrence, userId: ownerId, completion: { (userModel) in
                    
                    let group = Group(
                        openType: groupType,
                        article: article,
                        products: productsArray,
                        owner: userModel,
                        groupId: groupId
                    )
                    
                    completion(group)
                    
                })

                
            } catch {
                
                print(error)
            }
            

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func downloadGroupUser(group: Group, completion: @escaping ([String]) -> Void) {
        
        let refrence = Database.database().reference()
        
        guard let openType = group.openType else {
            return
        }
    refrence.child("group").child(openType.rawValue).child(group.groupId!).child("users").observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
        
            guard let memberIds = value?.allKeys as? [String] else {
            
                return
            }
        
            completion(memberIds)
        }
    }
    
    func downloadCommentUser(group: Group, completion: @escaping (CommentModel) -> Void) {

        let refrence = Database.database().reference()
        
        guard let openType = group.openType else {
            return
        }
    refrence.child("group").child(openType.rawValue).child(group.groupId!).child("comment").observe(.childAdded) { (snapshot) in
            
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
       
        guard let userInfo = self.user.userInfo() else {
            return
        }
        
        let refrence = Database.database().reference()
        refrence.child("users").child(userInfo.userId).child("userInfo").child("myGroup").child(myGroup.rawValue).child(groupType.rawValue).observe(.childAdded) { (snapshot) in
            
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
    
        guard let openType = group.openType else {
            return
        }
        
        refrence.child("group").child("\(openType.rawValue)").child("\(key)").child("article").setValue(
            
            [
                "title": group.article.title,
                "location" : group.article.location,
                "postDate": group.article.postDate,
                "content" : group.article.content
            ]
            
        )
    }
    
    private func uploadProduct(refrence: DatabaseReference, key: String, group: Group) {
        
        guard let openType = group.openType else {
            return
        }
        
        for value in group.products {
            
            refrence.child("group").child("\(openType.rawValue)").child("\(key)").child("products").child(value.productName).setValue(
                
                [
                    "productName": value.productName,
                    "numberOfItem": value.numberOfItem,
                    "price" : value.price,
                    "imageUrl": value.productImage ?? "",
                ]
                
            )
            
        }
        
    }
    
    private func uploadUser(refrence: DatabaseReference, key: String, group: Group) {
        
        guard let userInfo = self.user.userInfo() else {
            return
        }
        
        guard let openType = group.openType else {
            return
        }
        refrence.child("group").child(openType.rawValue).child(key).child("users").setValue(
            [
                "ownerId": group.owner!.userId,
            ]
        )
        refrence.child("users").child(userInfo.userId).child("userInfo").child("myGroup").child("own").child(openType.rawValue).updateChildValues(
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
            
            let aboutMyselfDic = value?["aboutMyself"] as? NSDictionary
            
            let description = aboutMyselfDic?["description"] as? String
            
            let phoneNumber = aboutMyselfDic?["phoneNumber"] as? String
            
            let aboutMyself = AboutMyself(phoneNumber: phoneNumber, description: description)
            
            completion(
                UserModel(
                userImage: userPicUrl,
                userName: userName,
                aboutSelf: aboutMyself,
                userId: userId
                )
            )
            
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
                title: title,
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
        
        guard let userInfo = self.user.userInfo() else {
            return
        }
        
        let refrence = Database.database().reference()
        refrence.child("users").child(userInfo.userId).child("userInfo").child("myGroup").child(myGroup.rawValue).child(groupType.rawValue).observe(.childAdded) { (snapshot) in
            
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
                title: title,
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
    
    func filterUser(userId: String, group: Group, completion: @escaping ([ProductModel]) -> Void) {
        
        guard let openType = group.openType else {
            return
        }

        let refrence = Database.database().reference()
        refrence.child("users").child(userId).child("userInfo").child("myGroup").child("join").child(openType.rawValue).child(group.groupId!).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            guard let productNames = value?.allKeys as? [String] else {
                return
            }
            
            var products: [ProductModel] = []
            
            for productName in productNames {
                
                guard let product = value?[productName] as? NSDictionary,
                    let numberOfItem = product["numberOfItem"] as? Int,
                    let price = product["price"] as? Int,
                    let image = product["productPicUrl"] as? String else {
                        return
                }
                
                let aProduct = ProductModel(productName: productName, productImage: image, numberOfItem: numberOfItem, price: price)
                
                products.append(aProduct)
            }
            
            completion(products)
            
        }
        
    }
    
    func deleteValue(group: Group) {
        
        let refrence = Database.database().reference()
        
        guard let groupId = group.groupId else {
            return
        }
        
        guard let openType = group.openType else {
            return
        }

        
        if let memberIds = group.memberID {
            
            for memberId in memberIds {
                refrence.child("users").child(memberId).child("userInfo").child("myGroup").child("join").child(openType.rawValue).child(groupId).removeValue()
                
            }
            
        }
    refrence.child("users").child(group.owner!.userId).child("userInfo").child("myGroup").child("own").child(openType.rawValue).child(groupId).removeValue()

        refrence.child("group").child(openType.rawValue).child(groupId).removeValue()
    }
    
    func detectChildRemove(openGroupType: OpenGroupType, completion: @escaping ([String]) -> Void) {
        
        let refrence = Database.database().reference()
        
        refrence.child("group").observeSingleEvent(of: .childRemoved) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            guard let keys = value?.allKeys as? [String] else {
                return
            }
            
            completion(keys)
        }
        
    }
    
    func updateAboutMyself(description: String?, phoneNumber: String?) {
        
        guard let userInfo = self.user.userInfo() else {
            return
        }
        
        let refrence = Database.database().reference()
        
        let childUpdates = [
            "/users/\(userInfo.userId)/userInfo/aboutMyself/description": description,
            "/users/\(userInfo.userId)/userInfo/aboutMyself/phoneNumber": phoneNumber
            ]
        
        refrence.updateChildValues(childUpdates as [AnyHashable : Any])

    }
    
}
