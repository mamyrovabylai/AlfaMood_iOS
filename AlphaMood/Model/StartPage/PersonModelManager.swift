//
//  PersonModelManager.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/28/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

class PersonModelManager {
    
   
    
    func createPerson() -> PersonModel {
        var id: String!
        id = getUserID()
        if id == nil {
            id = generateUserId()
        }
        let date = getLastDate()
        let lastMood = getLastMood()
        let pinned = getStateOfPinned()
        
        return PersonModel(userId: id, mood: nil, date: date, lastMood: lastMood, isPinned: pinned)
        
    }
    
    private func getUserID() -> String?{
        if let userID = UserDefaults.standard.string(forKey: "AlfaBankUserID") {
            return userID
        } else {
            return nil
        }
    }
    private func generateUserId() -> String {
        let userID = UUID().uuidString
        UserDefaults.standard.set(userID, forKey: "AlfaBankUserID")
        UserDefaults.standard.synchronize()
        return userID
    }
    
    func getLastDate() -> Date? {
        if let date = UserDefaults.standard.object(forKey: "AlfaBankUserDate") as? Date{
            return date
        } else {
            return nil
        }
    }
    
    func getLastMood() -> MoodModel? {
        if let mood = UserDefaults.standard.object(forKey: "AlfaBankUserMood") as? Int {
            switch mood {
            case 0:
                return .neutral
            case 2:
                return .negative
            default:
                return .positive
            }
        } else {
            return nil
        }
    }
    
    func getStateOfPinned() -> Bool {
        return UserDefaults.standard.bool(forKey: "AlfaBankUserPinned")
    }
    
    
    
    
    
}
