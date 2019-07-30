//
//  UserDefTimer.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/23/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation



class Pin {
    static func getPin() -> String? {
        return (UserDefaults.standard.string(forKey: "AlfaBankUserPIN") ?? nil)
    }
    static func savePin(pin: String) {
        UserDefaults.standard.setValue(pin, forKey: "AlfaBankUserPIN")
    }
    
}
