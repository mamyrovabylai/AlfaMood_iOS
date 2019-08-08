//
//  PinViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/29/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

class PinViewModel {
    
    var person: PersonModel
    init(person: PersonModel){
        self.person = person
    }
    
    
    func getPin(completion: @escaping ([Int])->()){
        var rightPassword = ""
        Pin.getPin { (pin) in
            rightPassword = pin
            var rightPass = [Int]()
            rightPassword.forEach { (char) in
                rightPass.append(Int(String(char))!)
            }
            completion(rightPass)
        }
        
    }
    
    
    func pinUser() {
        person.pinUser()
    }
    
    func mainViewModel()-> MainViewModel {
        return MainViewModel(person: person)
    }
    
}
