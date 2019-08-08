//
//  HeaderViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/1/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase
class HeaderViewModel {
    private(set) var docRef: DocumentReference!
    private(set) var comment: String!
    private(set) var numLikes: String!
    private(set) var imgName: String!
    init(comment: CommentModel){
        self.docRef = comment.documentId
        self.comment = comment.comment
        self.numLikes = "\(comment.numLikes!)"
        
        
    }
    
    func getNameForImage(completion: @escaping ()->()){
        isLiked { (liked, _) in
            if liked {
                self.imgName = "star"
            } else {
                self.imgName = "whiteStar"
            }
            completion()
        }
    }
    
    func likeIt(completion: @escaping ()->()){
        
        isLiked { (liked, uid) in
            if liked {
                self.docRef.setData([
                    "usersLiked" : FieldValue.arrayRemove([uid]),
                    "numLikes" : FieldValue.increment(Int64(-1))
                    ], merge: true)
                self.imgName = "whiteStar"
            } else {
                self.docRef.setData([
                    "usersLiked" :  FieldValue.arrayUnion([uid]),
                    "numLikes" : FieldValue.increment(Int64(1))
                    ], merge: true)
                self.imgName = "star"
            }
            completion()
        }
    }
    
    private func isLiked(completion: @escaping (Bool, String)->()){
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            docRef.getDocument { (snap, error) in
                if let error = error{
                    print("Error1")
                } else {
                    guard let snapshot = snap?.data() else {print("error in guard userliked")
                        return
                    }
                    let userList = snapshot["usersLiked"] as? [String] ?? ["no users"]
                    if !userList.contains(uid){
                        completion(false, uid)
                    } else {
                        completion(true, uid)
                    }
                }
            }
            
        }
    }
}
