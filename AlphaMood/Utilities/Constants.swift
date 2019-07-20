//
//  Constants.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/16/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase
let REF_FOR_MOBILE = Firestore.firestore().collection("forMobile") 
let REF_FROM_ML = Firestore.firestore().collection("fromML")

let KEY_USER_ID = "userID"
let KEY_DATE = "date"
let KEY_NUMBER =  "number"
let KEY_COMMENT = "comment"

let PATH_MONTH = "months"
let PATH_STATISTICS = "statistics"
let PATH_NUMBER = "number"

let NAME_IMG_NEUTRAL = "neutral"
let NAME_IMG_POSITIVE = "smile"
let NAME_IMG_NEGATIVE = "angry"

let TEXT_NEUTRAL = "О чем бы вы хотели с нами поделиться, но это на вас никак не влияет?"
let TEXT_POSITIVE = "Почему вы себя чувствуете так хорошо? :)"
let TEXT_NEGATIVE = "Почему у вас не такое уж хорошее настроение?"

let TEXTVIEW_PLACEHOLDER = "Если есть коментарий можете оставить, но это не обязательно"
