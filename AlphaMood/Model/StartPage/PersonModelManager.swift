//
//  PersonModelManager.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/28/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase
class PersonModelManager {
    
   
    
    func createPerson(id: String, pinned: Bool? = nil, completion: @escaping (PersonModel)->()){
        var date: Date?
        getLastDate(userid: id) { (d) in
            date = d
        }
        
        var lastMood: MoodModel?
        getLastMood(userid: id) { (mood) in
            lastMood = mood
        }
        var isPinned: Bool!
        if let pinned = pinned {
            isPinned = pinned
            completion(PersonModel(userId: id, mood: nil, date: date, lastMood: lastMood, isPinned: isPinned))
        } else {
            getIsPinned(userid: id) { (pinned) in
                isPinned = pinned
                completion(PersonModel(userId: id, mood: nil, date: date, lastMood: lastMood, isPinned: isPinned))
            }
        }
        
        
    }
    
    
    func getLastDate(userid: String, completion: @escaping (Date?)->())  {
        Firestore.firestore().collection(PATH_USERS).document(userid).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snapshot = snap?.data() else {
                    return
                }
                var date: Date? = nil
                if let lastDate = snapshot[KEY_LAST_DATE] as? Timestamp {
                    date = Date(timeIntervalSince1970: TimeInterval(lastDate.seconds))
                }
                completion(date)
            }
        }
    }
    
    func getLastMood(userid: String, completion: @escaping (MoodModel?)->()) {
        Firestore.firestore().collection(PATH_USERS).document(userid).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snapshot = snap?.data() else {
                    return
                }
                var mood: MoodModel? = nil
                if let userMood = snapshot[KEY_USER_MOOD] as? Int {
                    mood = MoodModel(rawValue: userMood)
                }
                completion(mood)
            }
        }
    }
    func getIsPinned(userid: String, completion: @escaping (Bool)->())  {
        Firestore.firestore().collection(PATH_USERS).document(userid).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snapshot = snap?.data() else {
                    return
                }
                var isPinned = false
                if let pinned = snapshot[KEY_IS_PINNED] as? Bool {
                    isPinned = pinned
                }
                completion(isPinned)
            }
        }
    }
    
    
    
    
    
    
    
}
