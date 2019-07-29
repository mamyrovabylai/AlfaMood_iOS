//
//  SecondPageViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/29/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

class SecondPageViewModel {
    
    var mood: MoodModel!
    
    init(personModel: PersonModel){
        self.mood = personModel.userMood
    }
    
}
