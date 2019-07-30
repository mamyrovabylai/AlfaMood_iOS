//
//  SecondPageViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/29/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase

class SecondPageViewModel {
    
    var moodTitle: String!
    var listener: ListenerRegistration!
    var person: PersonModel!
    var mood: Int!
    
    required init(personModel: PersonModel){
        self.person = personModel
        switch self.person.userMood!{
        case .neutral:
            moodTitle = TEXT_NEUTRAL
        case .positive:
            moodTitle = TEXT_POSITIVE
        case .negative:
            moodTitle = TEXT_NEGATIVE
        }
        self.mood = person.userMood!.rawValue
    }
    
    
    func mainViewModel() -> MainViewModel {
        return MainViewModel(person: self.person)
    }
    
    // Works
    func getTopFive(completion: @escaping([String]?)->()){
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds)))
        let ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!)).collection("\(self.mood!)mood")
        if let _ = listener {
            self.listener.remove()
        }
        self.listener = ref.order(by: KEY_NUMBER, descending: true).limit(to: 5).addSnapshotListener{ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snap = snapshot else {
                    print("Error in guard")
                    return
                }
                if snap.documents.count == 0{
                    completion(nil)
                } else {
                    var top5 = [String]()
                    for doc in snap.documents{
                        if let comment = doc[KEY_COMMENT] as? String{
                            top5.append(comment)
                        }
                    }
                    completion(top5)
                }
            }
        }
    }
    
    func removeListener(){
        if self.listener != nil {
            self.listener.remove()
        }
    }
    
    func getFixedComment(comment: String, completion: @escaping ([String])->Void) {
        let uploadingData = FixComment(comment: comment)
        do {
            let jsonUploadingData = try? JSONEncoder().encode(uploadingData)
            var urlRequest = URLRequest(url: URL(string: URL_ML)!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.uploadTask(with: urlRequest, from: jsonUploadingData) { (data, response, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                } else {
                    guard let response = response as? HTTPURLResponse else {
                        print("Error in response")
                        return
                    }
                    print(response.statusCode)
                    
                    if let jsonUploadedData = data, let uploadedData = try? JSONDecoder().decode(FixedComments.self, from: jsonUploadedData) {
                        completion(uploadedData.comment)
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    func changeMood2(components: DateComponents,ref: DocumentReference, curRef: CollectionReference, batch: inout WriteBatch){
        // update or set mood // done but govnocode
        if let lastDate = self.person.lastDate, let lastMood = self.person.lastMood {
            let lastDay = Calendar.current.dateComponents([.day], from: lastDate)
            if ((lastDay.day!) == (components.day!)){
                if (lastMood != self.person.userMood) {
                    let lastRef = ref.collection("\(lastMood.rawValue)mood").document(PATH_NUMBER)
                    batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(-1))], forDocument: lastRef, merge: true)
                    
                    
                    self.person.updateDate()
                    self.person.updateLastMood()
                    batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], forDocument: curRef.document(PATH_NUMBER), merge: true)
                    
                } else {
                    self.person.updateDate()
                }
            } else {
                self.person.updateDate()
                self.person.updateLastMood()
                batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], forDocument: curRef.document(PATH_NUMBER), merge: true)
            }
        } else {
            self.person.updateDate()
            self.person.updateLastMood()
            batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], forDocument: curRef.document(PATH_NUMBER), merge: true)
        }
        
    }
    
    func changeMood(components: DateComponents,ref: DocumentReference, curRef: CollectionReference, batch: inout WriteBatch){
        // update or set mood 
        if let lastDate = self.person.lastDate, let lastMood = self.person.lastMood {
            let lastDay = Calendar.current.dateComponents([.day], from: lastDate)
            if ((lastDay.day!) == (components.day!)){
            let lastRef = ref.collection("\(lastMood.rawValue)mood").document(PATH_NUMBER)
                batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(-1))], forDocument: lastRef, merge: true)
                batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], forDocument: curRef.document(PATH_NUMBER), merge: true)
            } else {
                batch.setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], forDocument: curRef.document(PATH_NUMBER), merge: true)
            }
        }
       
    }
    
    func incrementComment(gComments: [String]?, curRef: CollectionReference,completion: @escaping (DocumentReference,String?, String)->()){
        
        // found existing comment and increased the counter - works
        var comments = [String]()
        var key_num = KEY_NUMBER
        if gComments == nil{
            comments.append("NO COMMENT")
            key_num = KEY_NUMBER2
        } else {
            comments = gComments!
        }
        for comment in comments{
            curRef.whereField(KEY_COMMENT, isEqualTo: comment).getDocuments { (snapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                } else {
                    guard let snap = snapshot else {
                        print("SNAP")
                        return
                    }
                    
                    if snap.documents.count == 0 {
                        let docRef = curRef.document()
                        completion(docRef, comment, key_num)
                        
                    } else {
                        let docID = snap.documents[0].documentID
                        let docRef = curRef.document(docID)
                       completion(docRef,nil, key_num)
                    }
                }
            }
        }
    }
    
    func writeComment(comments gComments: [String]?){
         //COnfiguration of reference
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds)))
        let ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!))
        let curRef = ref.collection("\(self.mood!)mood")
        var batch = Firestore.firestore().batch()
        changeMood(components: components, ref: ref, curRef: curRef, batch: &batch)
        incrementComment(gComments: gComments, curRef: curRef) { (docRef, comment, key_num) in
            if let comment = comment {
                batch.setData([KEY_COMMENT: comment, key_num: 1], forDocument: docRef)
            } else {
                batch.setData([key_num: FieldValue.increment(Int64(1))], forDocument: docRef, merge: true)
            }
            batch.commit { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.person.updateDate()
                    self.person.updateLastMood()
                }
            }
        }
        
        
        
        
        
        
        
        
    }
    
    
}
