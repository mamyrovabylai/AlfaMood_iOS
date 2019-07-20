//
//  CommentVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/18/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import Firebase
class CommentVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    var pickedIndex: Int!
    var userID: String!
    var writeAllowed: Bool!
    var documentID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Why your mood is \(pickedIndex!)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readyTapped(_ sender: Any) {
        Firestore.firestore().collection("forMobile").whereField("userID", isEqualTo: userID!).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let snap = snapshot else {
                    print("Error in snaphot")
                    return
                }
                if snap.documents.count == 0 {
                    self.writeAllowed = true
                    print("self.writeAllowed = true!!")
                } else {
                    let userDate = snap.documents[0]["date"] as? Timestamp
                    let now = Timestamp(date: Date()).seconds
                    if (now - userDate!.seconds == 10800) || (now - userDate!.seconds > 10800){
                        self.writeAllowed = true
                        print("self.writeAllowed = true!!2")
                        self.documentID = snap.documents[0].documentID
                    } else {
                        self.writeAllowed = false
                        print("self.writeAllowed = false!!2")
                    }
                }
                
                if self.writeAllowed {
                    if let dID = self.documentID{
                       let currentDate = Date()
                    Firestore.firestore().collection("forMobile").document(dID).setData(["date": currentDate], merge: true)
                        print("I merged date!!")
                        let fmt = DateFormatter()
                        fmt.dateFormat = "d"
                        let dayString = fmt.string(from: currentDate)
                        fmt.dateFormat = "M"
                        let monthString = fmt.string(from: currentDate)
                        fmt.dateFormat = "yyyy"
                        let yearString = fmt.string(from: currentDate)
                        print(dayString, monthString, yearString)
                        
                        let ref = Firestore.firestore()
                            .collection("fromML").document(yearString)
                        .collection("months").document("month\(monthString)")
                        .collection("statistics").document("\(dayString)day")
                            .collection("\(self.pickedIndex!)mood")
                        
                        ref.addDocument(data: ["comment": self.textView.text])
                        
                        ref.document("number").setData(["number": FieldValue.increment(Int64(1))], merge: true)
                        
                        
                        
                        
                    } else {
                        Firestore.firestore().collection("forMobile").addDocument(data: ["date": Date(), "userID": self.userID!])
                        print("I created date!!")
                    }
                }
                
                
            }
        }
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
