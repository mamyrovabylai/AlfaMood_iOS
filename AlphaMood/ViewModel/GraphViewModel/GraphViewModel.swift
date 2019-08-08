//
//  GraphViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/1/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase
class GraphViewModel{
    
    var listener: ListenerRegistration!
    var date: Date!
    init(date: Date){
        self.date = date
    }
    func getMoods(completion: @escaping([Int], [String])->()){
        let dateAfterDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateAfterDay!)
        let truncatedDate = Calendar.current.date(from: components)!
        let time = Timestamp(date: truncatedDate)
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            removeListener()
            self.listener = Firestore.firestore()
                .collection(PATH_USERS).document(uid)
            .collection(PATH_MOODS)
                .whereField(KEY_DATE, isLessThan: time)
            .order(by: KEY_DATE, descending: true)
            .limit(to: 7)
                .addSnapshotListener { (snap, error) in
                    if let error = error{
                        return
                    }
                    guard let snapshot = snap else {
                        return
                    }
                    var moods = [Int]()
                    var dates = [String]()
                    for doc in snapshot.documents{
                        var mood = doc.data()[KEY_THIS_DAY_MOOD] as? Int ?? -1
                        switch mood {
                        case 0:
                            mood = 180
                        case 1:
                            mood = 90
                        case 2:
                            mood = 0
                        default:
                            mood = 180
                        }
                        let date = doc.data()["date"] as? Timestamp ?? Timestamp(date: Date())
                        let iosDate = Date(timeIntervalSince1970: TimeInterval(date.seconds))
                        let components = Calendar.current.dateComponents([.day,.month,.year], from: iosDate)
                        moods.append(mood)
                        dates.append("\(components.day!)/\(components.month!)")
                        
                        
                    }
                    moods.reverse()
                    dates.reverse()
                    
                    completion(moods, dates)
            }
        }
    }
    
    func removeListener(){
        if listener != nil {
            listener.remove()
        }
    }
}
