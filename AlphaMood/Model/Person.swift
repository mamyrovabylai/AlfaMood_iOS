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
    
    
    init(userID: String, pickedIndex: Int){
        self.userID = userID
        self.pickedIndex = pickedIndex
    }
    
    func isWriteAllowed(completion: @escaping(Bool, String?)-> Void){
        
        REF_FOR_MOBILE.whereField(KEY_USER_ID, isEqualTo: self.userID!).getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                guard let snap = snapshot else {
                    print("Error in getting snapshot")
                    return
                }
                if snap.documents.count == 0{
                    completion(true, nil)
                    return
                } else {
                    guard let userDate = snap.documents[0]["date"] as? Timestamp else {
                        print("Can not get field data from doc")
                        completion(true, nil)
                        return
                    }
                    let nowDate = Date()
                    let now = Timestamp(date: nowDate).seconds
                    if (now - userDate.seconds > 10799) {
                        let documentID = snap.documents[0].documentID
                        completion(true,documentID)
                        return
                    } else {
                        let components = DateComponentsFormatter()
                        components.allowedUnits = [.hour, .minute, .second]
                            components.unitsStyle = .full
                        let threeHoursAfter = Date(timeIntervalSince1970: TimeInterval(userDate.seconds)).addingTimeInterval(TimeInterval(10800))
                        
                        let string = components.string(from: nowDate, to: threeHoursAfter)
                        completion(false, string)
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
    
    
}
