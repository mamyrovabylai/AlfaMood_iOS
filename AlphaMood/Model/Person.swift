//
//  Person.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/20/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase
class Person {
    private(set) var userID: String!
    private(set) var pickedIndex: Int!
    private(set) var documentID: String? = nil
    
    
    init(userID: String, pickedIndex: Int){
        self.userID = userID
        self.pickedIndex = pickedIndex
    }
    
    func changePickedIndex(index: Int){
        self.pickedIndex = index
    }
    
    func isWriteAllowed(completion: @escaping(Bool, Int)-> Void){
        
        REF_FOR_MOBILE.whereField(KEY_USER_ID, isEqualTo: self.userID!).getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                guard let snap = snapshot else {
                    print("Error in getting snapshot")
                    return
                }
                if snap.documents.count == 0{
                    completion(true, 0)
                    return
                } else {
                    guard let userDate = snap.documents[0]["date"] as? Timestamp else {
                        print("Can not get field data from doc")
                        completion(true, 0)
                        return
                    }
                    let nowDate = Date()
                    let now = Timestamp(date: nowDate).seconds
                    if (now - userDate.seconds > 10799) {
                        let documentID = snap.documents[0].documentID
                        self.documentID = documentID
                        completion(true, 0)
                        return
                    } else {
                        completion(false, Int(userDate.seconds + 10800 - now))
                        return
                    }
                }
                
            }
        }
    }
    
    func writeComment(comment: String, documentID: String?){
        let now = Date()
        if let documentID = documentID{
            REF_FOR_MOBILE.document(documentID).setData([KEY_DATE: now], merge: true)
        } else {
            REF_FOR_MOBILE.addDocument(data: [KEY_DATE: now, KEY_USER_ID: self.userID!])
        }
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: TimeInterval(Timestamp(date: now).seconds)))
        print(components.day!, components.month!, components.year!)
        
        let ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!))
            .collection("\(self.pickedIndex!)mood")
        
        if comment != ""{
            ref.addDocument(data: [KEY_COMMENT: comment])
        }
        
        ref.document(PATH_NUMBER).setData([KEY_NUMBER: FieldValue.increment(Int64(1))], merge: true)
        
        
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
    
    
}
