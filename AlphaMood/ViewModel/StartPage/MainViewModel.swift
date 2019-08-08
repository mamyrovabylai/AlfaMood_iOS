//
//  MainModelView.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/29/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase

class MainViewModel{
    
    var imageNames: [String] = [NAME_IMG_NEUTRAL, NAME_IMG_POSITIVE, NAME_IMG_NEGATIVE]
    
    let components = DateComponentsFormatter()
    
    var handler: AuthStateDidChangeListenerHandle!
    
    
    
    func getStringForTimer(left: Int) -> String {
        return components.string(from: TimeInterval(left))!
    }
    
    var personMM: PersonModelManager! = PersonModelManager()
    
    var person: PersonModel!
    
    
    init(person: PersonModel? = nil){
            self.person = person
        
        
        components.allowedUnits = [.hour, .minute, .second]
        components.unitsStyle = .full
    }
    
    
    
    
    
    
    func secondPageViewModel(pickedIndex: Int) -> SecondPageViewModel? {
        var mood: MoodModel?
        mood = MoodModel(rawValue: pickedIndex)
       
        if let mood = mood{
            person.setCurrenMood(mood: mood)
            return SecondPageViewModel(personModel: self.person)
        } else {
            return nil
        }
    }
    
    func pinViewModel() -> PinViewModel {
        return PinViewModel(person: self.person)
    }
    
    func isUserPinned() -> Bool {
        if let pinned = person.isPinned {
            return pinned
        } else {
            return false
        }
    }
    
    func checkAllowence() -> (Bool, Int?) {
        guard let person = self.person else {
            return (false, 0)
        }
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
    
    func isUserLogged(completion: @escaping (Bool)->Void){
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil{
                completion(false)
            } else {
                self.personMM.createPerson(id: Auth.auth().currentUser!.uid){ (gotPerson) in
                    self.person = gotPerson
                    completion(true)
                }
                
            }
        })
    }
    
    func authorizeAnon(completion: @escaping ()->()){
        Auth.auth().signInAnonymously { (res, error) in
            if let error = error {
                return
            } else {
                guard let result = res else  { return }
                let userId = result.user.uid
                Firestore.firestore().collection(PATH_USERS).document(userId).setData([
                     KEY_USER_ID2 : userId
                    ], completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        } else {
                            self.personMM.createPerson(id: Auth.auth().currentUser!.uid){ (gotPerson) in
                                self.person = gotPerson
                                completion()
                            }
                        }
                })
                
            }
        }
    }
}
    
    

