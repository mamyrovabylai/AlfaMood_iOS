//
//  MainModelView.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/29/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

class MainViewModel{
    
    var imageNames: [String] = [NAME_IMG_NEUTRAL, NAME_IMG_POSITIVE, NAME_IMG_NEGATIVE]
    
    let components = DateComponentsFormatter()
    
    func getStringForTimer(left: Int) -> String {
        return components.string(from: TimeInterval(left))!
    }
    
    var personMM: PersonModelManager!
    
    var person: PersonModel!
    
    
    init(person: PersonModel? = nil){
        if person == nil{
            self.personMM = PersonModelManager()
            self.person = personMM.createPerson()
        } else {
            self.person = person
        }
        
        components.allowedUnits = [.hour, .minute, .second]
        components.unitsStyle = .full
    }
    
    
    
    func secondPageViewModel(pickedIndex: Int) -> SecondPageViewModel? {
        var mood: MoodModel?
        switch pickedIndex {
        case 0:
            mood = .neutral
        case 1:
            mood = .positive
        case 2:
            mood = .negative
        default:
            mood = nil
            
        }
        if let mood = mood{
            person.setCurrenMood(mood: mood)
            return SecondPageViewModel(personModel: self.person)
        } else {
            print("Mood is nil")
            return nil
        }
    }
    
    func pinViewModel() -> PinViewModel {
        return PinViewModel(person: self.person)
    }
    
    func isUserPinned() -> Bool {
        return person.isPinned
    }
    
    func checkAllowence() -> (Bool, Int?) {
        if let lastDate = person.lastDate {
            if Date().timeIntervalSince(lastDate) > 59 {
                return (true, nil)
            }  else {
                return (false, Int(60 - Date().timeIntervalSince(lastDate)))
            }
        } else {
            return (true, nil)
        }
    }
}
    
    

