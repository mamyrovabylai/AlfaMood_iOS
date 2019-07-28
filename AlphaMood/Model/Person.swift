//
//  Person.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/20/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import FirebaseFirestore
class Person {
    private(set) var userID: String!
    private(set) var pickedIndex: Int!
    
    var listener: ListenerRegistration!
    init(userID: String, pickedIndex: Int){
        self.userID = userID
        self.pickedIndex = pickedIndex
    }
    func changePickedIndex(index: Int){
        self.pickedIndex = index
    }
    
    
    func writeComment(comment gComment: String){
        // COnfiguration of reference
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds)))
        let ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!))
        let curRef = ref.collection("\(self.pickedIndex!)mood")
        
        
        // update or set mood // done but govnocode
        if let lastDate = UserDefaults.standard.object(forKey: "AlfaBankUserDate") as? Date {
            let lastDay = Calendar.current.dateComponents([.day], from: lastDate)
            let lastMood = UserDef.getMood()
            if ((lastDay.day!) == (components.day!)){
                if (lastMood != self.pickedIndex) {
                    let lastRef = ref.collection("\(lastMood)mood")
                    lastRef.document(PATH_NUMBER).setData([KEY_NUMBER2: FieldValue.increment(Int64(-1))], merge: true)
                    
                    
                    UserDef.updateDate()
                    UserDef.updateMood(mood: self.pickedIndex)
                    curRef.document(PATH_NUMBER).setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], merge: true)
                } else {
                    UserDef.updateDate()
                }
            } else {
                UserDef.updateDate()
                UserDef.updateMood(mood: self.pickedIndex)
                curRef.document(PATH_NUMBER).setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], merge: true)
            }
        } else {
            UserDef.updateDate()
            UserDef.updateMood(mood: self.pickedIndex)
            curRef.document(PATH_NUMBER).setData([KEY_NUMBER2: FieldValue.increment(Int64(1))], merge: true)
        }
        
        
        // found existing comment and increased the counter
        var comment = gComment
        var key_num = KEY_NUMBER
        if comment == ""{
            comment = "NO COMMENT"
            key_num = KEY_NUMBER2
        }
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
                    curRef.addDocument(data: [KEY_COMMENT: comment,key_num: 1])
                } else {
                    let docID = snap.documents[0].documentID
                    curRef.document(docID).updateData([key_num: FieldValue.increment(Int64(1))])
                }
            }
        }
        
        
    }
    
    
    
    
    
    
    func getFixedComment(comment: String, completion: @escaping (String)->Void) {
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
                    
                    if let jsonUploadedData = data, let uploadedData = try? JSONDecoder().decode(FixComment.self, from: jsonUploadedData) {
                        completion(uploadedData.comment)
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func getTopFive(completion: @escaping([String]?)->()){
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds)))
        let ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!)).collection("\(self.pickedIndex!)mood")
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
    
    
    
}
