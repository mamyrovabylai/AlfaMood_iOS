//
//  MainModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/28/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase
class PersonModel{
    private(set) var userId: String!
    private(set) var userMood: MoodModel?
    private(set) var lastDate: Date?
    private(set) var lastMood: MoodModel?
    private(set) var isPinned: Bool?
    private(set) var nowDate: Date!
    private(set) var ref: DocumentReference!
    private(set) var curRef: CollectionReference!
    
    private var components: DateComponents!
    private var batch: WriteBatch!
    
    
    init(userId: String, mood: MoodModel?, date: Date?, lastMood: MoodModel?, isPinned: Bool?){
        self.userId = userId
        self.userMood = mood
        self.lastDate = date
        self.lastMood = lastMood
        self.isPinned = isPinned
        self.nowDate = Date()
        self.components = Calendar.current.dateComponents([.day, .month, .year], from: nowDate)
        
    }
    
    func updateDate(date: Date){
            self.lastDate = date
    }
    func setCurrenMood(mood: MoodModel){
        self.userMood = mood
    }
    func updateLastMood(){ Firestore.firestore().collection(PATH_USERS).document(self.userId).setData([KEY_USER_MOOD: self.userMood!.rawValue], merge: true)
        self.lastMood = self.userMood
    }
    func pinUser() { Firestore.firestore().collection(PATH_USERS).document(self.userId).setData([KEY_IS_PINNED: true], merge: true)
        self.isPinned = true
    }
    
    func changeMood(){
        // update or set mood
        if let lastDate = self.lastDate, let lastMood = self.lastMood {
            let lastDay = Calendar.current.dateComponents([.day], from: lastDate)
            if ((lastDay.day!) == (components.day!)){
                let lastRef = ref.collection("\(lastMood.rawValue)\(PATH_MOOD)").document(PATH_NUMBER)
                batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(-1))], forDocument: lastRef, merge: true)
                            }
        }
        
        batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], forDocument:
            curRef.document(PATH_NUMBER), merge: true)
        // add to user's history mood and update lastMood & lastDate
        let docRefForUser =  Firestore.firestore().collection(PATH_USERS).document(self.userId)
        let moodsRef = docRefForUser.collection(PATH_MOODS).document("\(components.day!)_\(components.month!)_\(components.year!)")
        batch.setData([KEY_THIS_DAY_MOOD: self.userMood!.rawValue, KEY_DATE: self.nowDate], forDocument: moodsRef)
        batch.setData([
            KEY_USER_MOOD: self.userMood!.rawValue,
            KEY_LAST_DATE: Timestamp(date: Date())
            ], forDocument: docRefForUser, merge: true)
    }
    
    
    // goes for each comment to increment it in database
    func recursionComments(comments: [String],initialComment: String, current: Int, total: Int){
        let comment = comments[current]
        curRef.whereField(KEY_COMMENT, isEqualTo: comment).getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let snap = snapshot else {
                return
            }
            
            if snap.documents.count == 0 {
                let docRef = self.curRef.document()
                self.batch.setData([KEY_COMMENT: comment, KEY_NUMBER: FieldValue.increment(Int64(1)), KEY_INIT_COMMENT: FieldValue.arrayUnion([initialComment]),
                                    KEY_LIKES: 0
                    ], forDocument: docRef)
                
            } else {
                
                for doc in snap.documents{
                    let docID = doc.documentID
                    let docRef = self.curRef.document(docID)
                    self.batch.setData([KEY_NUMBER: FieldValue.increment(Int64(1)), KEY_INIT_COMMENT: FieldValue.arrayUnion([initialComment])
                                        ], forDocument: docRef, merge: true)
                }
                
            }
            
            if (current+1 < total){
                self.recursionComments(comments: comments,initialComment: initialComment, current: current + 1, total: total)
            } else {
                self.batch.commit { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.updateDate(date: self.nowDate)
                        self.updateLastMood()
                        
                    }
                }
            }
        }
            
    }
    
    // changes mood and increments the number of each comment in database
    func writeComment(comments gComments: [String]?, initialComment: String?){
        //COnfiguration of reference
        
        self.nowDate = Date()
        self.components = Calendar.current.dateComponents([.day, .month, .year], from: self.nowDate)
        
        self.ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!))
        self.curRef = ref.collection("\(self.userMood!.rawValue)\(PATH_MOOD)")
        
        batch = Firestore.firestore().batch()
        
        changeMood()
        
        if gComments == nil{
            batch.setData([KEY_NO_COMMENTS: FieldValue.increment(Int64(1))], forDocument:  curRef.document(PATH_NUMBER), merge: true)
            batch.commit() { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.updateDate(date: self.nowDate)
                    self.updateLastMood()
                }
            }
        } else {
            recursionComments(comments: gComments!,initialComment: initialComment!, current: 0, total: gComments!.count)
        }
        
    }
    
    
}

    
    

