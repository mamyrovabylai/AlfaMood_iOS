//
//  SecondPageViewModel.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/29/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation
import Firebase



class SecondPageViewModel {
    
    var moodTitle: String!
    var listener: ListenerRegistration!
    var person: PersonModel!
    var mood: Int!
    
    required init(personModel: PersonModel){
        self.person = personModel
        
        switch self.person.userMood!{
        case .neutral:
            moodTitle = TEXT_NEUTRAL
        case .positive:
            moodTitle = TEXT_POSITIVE
        case .negative:
            moodTitle = TEXT_NEGATIVE
        }
        self.mood = person.userMood!.rawValue
    }
    
    
    func mainViewModel() -> MainViewModel {
        return MainViewModel(person: self.person)
    }
    
    // Works
    func getTopFive(completion: @escaping([String]?)->()){
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date(timeIntervalSince1970: TimeInterval(Timestamp(date: Date()).seconds)))
        let ref = REF_FROM_ML.document(String(components.year!))
            .collection(PATH_MONTH).document(String(components.month!))
            .collection(PATH_STATISTICS).document(String(components.day!)).collection("\(self.mood!)\(PATH_MOOD)")
        removeListener()
        self.listener = ref.order(by: KEY_NUMBER, descending: true).limit(to: 5).addSnapshotListener{ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let snap = snapshot else {
                    return
                }
                if snap.documents.count == 0{
                    completion(nil)
                } else {
                    var top5 = [String]()
                    for doc in snap.documents{
                        if let comment = doc.data()[KEY_COMMENT] as? String{
                            top5.append(comment)
                        }
                    }
                    completion(top5)
                }
            }
        }
    }
    
    func removeListener(){
        if self.listener != nil {
            self.listener.remove()
        }
    }
    
    func getFixedComment(comment: String, completion: @escaping ([String]?)->Void) {
        let uploadingData = FixComment(comment: comment)
        do {
            let jsonUploadingData = try? JSONEncoder().encode(uploadingData)
            var urlRequest = URLRequest(url: URL(string: URL_ML)!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.uploadTask(with: urlRequest, from: jsonUploadingData) { (data, response, error) in
                if let err = error {
                    print(err.localizedDescription)
                    completion(nil)
                    return
                } else {
                    guard let response = response as? HTTPURLResponse else {
                        return
                    }
                    
                    if let jsonUploadedData = data, let uploadedData = try? JSONDecoder().decode(FixedComments.self, from: jsonUploadedData) {
                        print(uploadedData.comment)
                        completion(uploadedData.comment)
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func writeComment(comments: [String]?, initialComment: String? ){
        person.writeComment(comments: comments, initialComment: initialComment)
    }
    
    
}
