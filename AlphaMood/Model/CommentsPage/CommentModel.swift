//
//  CommentModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/31/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase

class CommentModel {
    private(set) var numLikes: Int!
    private(set) var comment: String!
    private(set) var documentId: DocumentReference!
    
    init(numLikes: Int, comment: String,  documentId: DocumentReference){
        self.numLikes = numLikes
        self.comment = comment
        self.documentId = documentId
    }
    
    func getUserLiked(completion: @escaping([String])->()){
        documentId.getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snapshot = snap?.data() else { 
                    return
                }
                if let usersList = snapshot[KEY_USER_LIKED] as? [String]{
                    completion(usersList)
                }
            }
        }
    }
}
