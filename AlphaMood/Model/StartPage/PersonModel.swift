//
//  MainModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/28/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

class PersonModel{
    private(set) var userId: String!
    private(set) var userMood: MoodModel?
    private(set) var lastDate: Date?
    private(set) var lastMood: MoodModel?
    private(set) var isPinned: Bool!
    
    
    init(userId: String, mood: MoodModel?, date: Date?, lastMood: MoodModel?, isPinned: Bool){
        self.userId = userId
        self.userMood = mood
        self.lastDate = date
        self.lastMood = lastMood
        self.isPinned = isPinned
    }
    
    func updateDate(){
        UserDefaults.standard.set(Date(), forKey: "AlfaBankUserDate")
        UserDefaults.standard.synchronize()
        self.lastDate = Date()
    }
    func setCurrenMood(mood: MoodModel){
        self.userMood = mood
    }
    func updateLastMood(){
        UserDefaults.standard.set(self.userMood!.rawValue, forKey: "AlfaBankUserMood")
        UserDefaults.standard.synchronize()
        self.lastMood = self.userMood
    }
    func pinUser() {
        UserDefaults.standard.set(true, forKey: "AlfaBankUserPinned")
        self.isPinned = true
    }
    
    
}
