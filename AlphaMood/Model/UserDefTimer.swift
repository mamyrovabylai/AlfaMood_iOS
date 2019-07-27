//
//  UserDefTimer.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/23/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import UIKit

protocol UserDefProtocol {
    func presentAlert(alert: UIAlertController)
    func checkAgain()
}

class UserDef {
    
    var delegate: UserDefProtocol?
    
    
    init () {
        
    }
    
    
    
    
    // Time Checker
    static func unableButton(buttonNext: UIButton) {
        buttonNext.isEnabled = false
        buttonNext.alpha = 0.3
    }
    static func enableButton(buttonNext: UIButton, timerLabel: UILabel) {
        buttonNext.isEnabled = true
        buttonNext.alpha = 1
        timerLabel.text = ""
    }
    
    static func fireTimer(left: Int, buttonNext: UIButton, timerLabel: UILabel){
        UserDef.unableButton(buttonNext: buttonNext)
        let components = DateComponentsFormatter()
        components.allowedUnits = [.hour, .minute, .second]
        components.unitsStyle = .full
        var timeLeft = left
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if timeLeft < 1 {
                UserDef.enableButton(buttonNext: buttonNext, timerLabel: timerLabel)
                timer.invalidate()
                return
            }
            let string = components.string(from: TimeInterval(timeLeft))
            timerLabel.text = "Осталось : \(string!)"
            timeLeft -= 1
            }.fire()
    }
    
    func checkAllowence(buttonNext: UIButton, timerLabel: UILabel) {
        UserDef.unableButton(buttonNext: buttonNext)
        if let lastDate = UserDefaults.standard.object(forKey: "AlfaBankUserDate") as? Date {
            
                
                if Date().timeIntervalSince(lastDate) > 59 {
                    DispatchQueue.main.async {
                        UserDef.enableButton(buttonNext: buttonNext, timerLabel: timerLabel)
                    }
                }  else {
                    DispatchQueue.main.async {
                        UserDef.fireTimer(left: Int(60 - Date().timeIntervalSince(lastDate)), buttonNext: buttonNext, timerLabel: timerLabel )
                    }
                }
            
            
        } else {
            UserDef.enableButton(buttonNext: buttonNext, timerLabel: timerLabel)
        }
    }
    
    // User ID and Object Person
    static func saveUserId() -> String{
        let userID = UUID().uuidString
        UserDefaults.standard.set(userID, forKey: "AlfaBankUserID")
        UserDefaults.standard.synchronize()
        return userID
        
    }
    static func getUserID() -> String?{
        if let userID = UserDefaults.standard.string(forKey: "AlfaBankUserID") {
            return userID
            
        } else {
            return nil
        }
    }
    
    static func createPerson() -> Person{
        if let id = UserDef.getUserID() {
            return Person(userID: id, pickedIndex: 1)
        } else {
            return Person(userID: UserDef.saveUserId(), pickedIndex: 1)
        }
    }
    
    // Date
    static func updateDate(){
        UserDefaults.standard.set(Date(), forKey: "AlfaBankUserDate")
        UserDefaults.standard.synchronize()
    }
    
    // Mood
    static func getMood() -> Int {
        return (UserDefaults.standard.integer(forKey: "AlfaBankUserMood") - 1 )
    }
    
    static func updateMood(mood: Int){
        UserDefaults.standard.set((mood+1), forKey: "AlfaBankUserMood")
        UserDefaults.standard.synchronize()
    }
    
    //PIN
    
    static func getPin() -> String? {
        return (UserDefaults.standard.string(forKey: "AlfaBankUserPIN") ?? nil)
    }
    static func savePin(pin: String) {
        UserDefaults.standard.setValue(pin, forKey: "AlfaBankUserPIN")
    }
    static func getUserPinned() -> Bool {
        return UserDefaults.standard.bool(forKey: "AlfaBankUserPinned")
    }
    static func UserPinned(mode: Bool) {
        UserDefaults.standard.set(mode, forKey: "AlfaBankUserPinned")
    }
    
}
