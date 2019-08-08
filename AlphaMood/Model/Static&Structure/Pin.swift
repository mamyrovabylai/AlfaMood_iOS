//
//  UserDefTimer.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/23/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

import Firebase


class Pin {
    static func getPin(completion: @escaping (String)->()){
        Firestore.firestore().collection(PATH_ADMIN).document(PATH_PIN).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snapshot = snap!.data() else {
                    return
                }
                let pin = snapshot[KEY_PIN] as! String
                completion(pin)
                
            }
        }
    }
   
    
}
