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
let KEY_USER_ID2 = "userId"
let KEY_DATE = "date"
let KEY_NUMBER =  "number"
let KEY_LIKES =  "numLikes"
let KEY_NUMBER2 =  "_number_"
let KEY_COMMENT = "comment"
let KEY_INIT_COMMENT = "initialComments"
let KEY_PIN = "pin"
let KEY_USER_LIKED = "userLiked"
let KEY_USER_MOOD = "userMood"
let KEY_IS_PINNED = "isPinned"
let KEY_NO_COMMENTS = "numWithNoComments"
let KEY_THIS_DAY_MOOD = "moodForThisDay"
let KEY_LAST_DATE = "lastDate"



let PATH_MONTH = "months"
let PATH_STATISTICS = "statistics"
let PATH_NUMBER = "number"
let PATH_USERS = "users"
let PATH_MOOD = "mood"
let PATH_MOODS = "moods"
let PATH_FROMML = "fromML"
let PATH_ADMIN = "admin"
let PATH_PIN = "pin"

let NAME_IMG_NEUTRAL = "neutral"
let NAME_IMG_POSITIVE = "smile"
let NAME_IMG_NEGATIVE = "angry"

let TEXT_NEUTRAL = "О чем бы вы хотели с нами поделиться?"
let TEXT_POSITIVE = "Почему вы себя чувствуете так хорошо? :)"
let TEXT_NEGATIVE = "Почему у вас не такое уж хорошее настроение?"

let TEXTVIEW_PLACEHOLDER = "Если есть коментарий можете оставить"

let URL_ML = "http://madiyarmukushev.pythonanywhere.com/comments"

let TIME_PERIOD = 60

let ALERT_TITLE = "Подключение к интернету"
let ALERT_MSG = "Что то не так с интернетом"
let ALERT_ACTTITLE = "Хорошо"
let PINALERT_TITLE = "Пароль"
let PINALERT_MSG = "Неправильный пароль"
let PINALERT_ACTTITLE = "Ok"



let SEGUE_COMMENT = "mainGoComment"
let SEGUE_PIN = "mainGoPinCode"

let DEQUEUE_HEADER = "headerCell"
let HEIGHT_HEADER = 50
let DEQUEUE_CELL = "commentCell"
let HEIGHT_CELL = 30

let SMILE_EMOJI = "🙂"
let NEUTRAL_EMOJI = "😐"
let NEGATIVE_EMOJI = "😔"
let TITLE_GRAPH = "Последние настроения"
let ZTITLE_GRAPH = "Пока что нет ни одного настроения.."
let FONT_GRAPH = "Serif"
let BACK_CLR_INT = 2899536

let DATEPICKER_NIBNAME = "datePicker"

let DEFAULT_COMMENT = "no comment"
let DEFAULT_INIT_COMMENT = "no inital comment"

let NO_COMMENTS = "Комментариев пока нет"













