//
//  CommentVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/18/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import Firebase

protocol CommentDelegate {
    func doCheck(left: Int)
}
class CommentVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    //Variables
    var person: Person!
    var delegate: CommentDelegate?

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
       
                if let comment = self.textView.text{
                    self.person.getFixedComment(comment: comment, completion: { (comment) in
                        self.person.writeComment(comment: comment, documentID: self.person.documentID)
                    })
                } else {
                    self.person.writeComment(comment: "", documentID: self.person.documentID)
                }
        
        textView.text = ""
        self.delegate?.doCheck(left: 10800)
        navigationController?.popViewController(animated: true)
        
        
        
        
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
