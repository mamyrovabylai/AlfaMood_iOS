//
//  CommentsViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/31/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase

class CommentsViewModel {
    
    var mood: MoodModel = .positive
    private var listener: ListenerRegistration!
    var components: DateComponents!
    var mainRef: DocumentReference!
    var comments: [CommentModel]!
    var initialComments: [Int: [String]]!
    
    init (){
        self.components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        self.mainRef = Firestore.firestore().document("\(PATH_FROMML)/\(components.year!)/\(PATH_MONTH)/\(components.month!)/\(PATH_STATISTICS)/\(components.day!)")
        self.comments = [CommentModel]()
        self.initialComments = [:]
        
    }
    
    func getComments(completion: @escaping ()->()){
        
        self.components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        self.mainRef = Firestore.firestore().document("\(PATH_FROMML)/\(components.year!)/\(PATH_MONTH)/\(components.month!)/\(PATH_STATISTICS)/\(components.day!)")
        
        listener = mainRef.collection("\(mood.rawValue)\(PATH_MOOD)").order(by: KEY_LIKES, descending: true).addSnapshotListener({ (snap, error) in
            
            self.comments = []
            self.initialComments = [:]
            
            if let error = error{
                print(error.localizedDescription)
                return
            } else {
                guard let snapshot = snap else {
                    return
                }
                if snapshot.documents.count == 0{
                    self.comments = [CommentModel]()
                    
                } else {
                    for i in 0..<snapshot.documents.count{
                        let doc = snapshot.documents[i]
                        if (doc.documentID != PATH_NUMBER){
                            let comment = doc.data()[KEY_COMMENT] as? String ?? DEFAULT_COMMENT
                            let initialCommentsF = doc.data()[KEY_INIT_COMMENT] as? [String] ?? [DEFAULT_INIT_COMMENT]
                            let numLikes = doc.data()[KEY_LIKES] as? Int ?? 0
                            let docId = self.mainRef.collection("\(self.mood.rawValue)\(PATH_MOOD)").document(doc.documentID)
                            let commentModel = CommentModel(numLikes: numLikes, comment: comment, documentId: docId)
                            self.comments.append(commentModel)
                            self.initialComments[i] = []
                            for g in 0..<initialCommentsF.count{
                                let iComment = initialCommentsF[g]
                                self.initialComments[i]!.append(iComment)
                            }
                            
                        }
                    }
                }
                completion()
            }
        })
    }
    
    func numberOfComments() -> Int {
        return self.comments.count
    }
    
    func changeMood(mood: MoodModel){
        self.removeListener()
        self.mood = mood
       
    }
    
    func cellViewModel(hIndex: Int, cIndex: Int)-> CommentCellViewModel{
        return CommentCellViewModel(initialComment: self.initialComments![hIndex]![cIndex])
    }
    func headerViewModel(index: Int)-> HeaderViewModel{
        return HeaderViewModel(comment: comments[index]) 
    }
    
    func removeListener(){
        if self.listener != nil{
            self.listener.remove()
        }
    }
}
