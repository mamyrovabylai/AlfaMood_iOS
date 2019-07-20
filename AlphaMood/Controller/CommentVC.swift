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
    
    //Outlets
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    //Variables
    var person: Person!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewForLabel.layer.cornerRadius = 8
        readyButton.layer.cornerRadius = 8
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        setPlaceholder()
        textView.delegate = self
        
        switch person.pickedIndex{
        case 0:
            label.text = TEXT_NEUTRAL
        case 1:
            label.text = TEXT_POSITIVE
        case 2:
            label.text = TEXT_NEGATIVE
        default:
            label.text = ""
        }
        
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

extension CommentVC: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setPlaceholder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func setPlaceholder(){
        textView.text = TEXTVIEW_PLACEHOLDER
        textView.textColor = .darkGray
    }
}
