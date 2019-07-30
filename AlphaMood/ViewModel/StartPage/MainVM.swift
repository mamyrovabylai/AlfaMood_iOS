//
//  MainVM.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/28/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

class MainViewModel{
    var imageNames: [String]
    
    weak var personMM: PersonModelManager!
    
    init(personMM: PersonModelManager){
        self.personMM = personMM
    }
    
    
}
