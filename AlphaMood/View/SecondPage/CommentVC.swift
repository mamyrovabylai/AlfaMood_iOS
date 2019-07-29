//
//  CommentVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/18/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import Firebase
import Hashtags
protocol CommentDelegate {
    func doCheck(left: Int)
}

class CommentVC: UIViewController {
    
    @IBOutlet weak var hasttagViewHeight: NSLayoutConstraint!
    
    //Outlets
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var hashtagView: HashtagView!
    
    //Variables
    var person: Person!
    var delegate: CommentDelegate?
    var top5 = [String]()
    
    override func viewWillDisappear(_ animated: Bool) {
        if let listener = person.listener {
            listener.remove()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        
        // Configuration of views
        viewForLabel.layer.cornerRadius = 8
        readyButton.layer.cornerRadius = 8
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        setPlaceholder()
        // texview's delegation
        textView.delegate = self
        hashtagView.delegate = self
        //configuration of view which depends on mood
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
        // Uploading top 5 comments
        hashtagView.alpha = 1
        person.getTopFive { (top5) in
            if let top = top5{
                self.hashtagView.removeTags()
                top.forEach({ (comment) in
                    let hash = HashTag(word: comment, withHashSymbol: true, isRemovable: false)
                    self.hashtagView.addTag(tag: hash)
                })
            }
            print("Completion worked")
        }
        //Configuration of view which depends on top 5 mood
        //...
        
        
    }
    
    
    // Sending a message
    @IBAction func readyTapped(_ sender: Any) {
        if let comment = self.textView.text, textView.textColor != UIColor.darkGray {
            self.person.getFixedComment(comment: comment, completion: { (comment) in
                self.person.writeComment(comment: comment)
            })
        } else {
            self.person.writeComment(comment: "")
        }
        self.textView.text = ""
        self.delegate?.doCheck(left: 60)
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

// Placeholder for textView
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

// HastagView
extension CommentVC: HashtagViewDelegate {
    func hashtagRemoved(hashtag: HashTag) {
        return
    }
    
    func viewShouldResizeTo(size: CGSize) {
        guard let constraint = self.hasttagViewHeight else {
            return
        }
        constraint.constant = size.height
        UIView.animate(withDuration: 0.4) {
            self.view.setNeedsLayout()
        }
    }
    
    func cellSelected(comment: String) {
        self.textView.text = comment
        textView.textColor = .black
        
        
    }
}