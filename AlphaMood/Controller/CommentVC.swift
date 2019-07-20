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
    var person: Person!

    override func viewDidLoad() {
        super.viewDidLoad()
        var textForLabel: String!
        switch person.pickedIndex{
        case 0:
            textForLabel = "О чем бы вы хотели с нами поделиться, но это на вас никак не влияет?"
        case 1:
            textForLabel = "Почему вы себя чувствуете так хорошо? :)"
        case 2:
            textForLabel = "Почему у вас не такое уж хорошее настроение?"
        default:
            textForLabel = ""
        }
        label.text = textForLabel
    }
    
    @IBAction func readyTapped(_ sender: Any) {
        person.isWriteAllowed { (response, documentID) in
            if response {
                let comment = self.textView.text
                self.person.writeComment(comment: comment ?? "", documentID: documentID)
            } else {
                let alert = UIAlertController(title: "Терпение", message: "Комментарий можно повторно отправлять по истечению трех часов :) \n У вас осталось \(documentID!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
