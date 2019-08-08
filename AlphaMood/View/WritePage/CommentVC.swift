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
    func fire(left: Int, viewModel: MainViewModel)
}

class CommentVC: UIViewController {
    var viewModel: SecondPageViewModel!
    // Outlets
    @IBOutlet weak var hasttagViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var hashtagView: HashtagView!
    
    //Variables
    var delegate: CommentDelegate?
    var top5 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration of views
        activityIndicator.isHidden = true
        
        viewForLabel.layer.cornerRadius = 8
        readyButton.layer.cornerRadius = 8
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        setPlaceholder()
        // texview's delegation
        textView.delegate = self
        hashtagView.delegate = self
        //configuration of view which depends on mood
        label.text = viewModel.moodTitle
        // Uploading top 5 comments - NO
        hashtagView.alpha = 1
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getTopFive { (top5) in
            if let top = top5{
                self.hashtagView.removeTags()
                top.forEach({ (comment) in
                    let hash = HashTag(word: comment, withHashSymbol: true, isRemovable: false)
                    self.hashtagView.addTag(tag: hash)
                })
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.removeListener()
    }
    
    
    // Sending a message - NO
    @IBAction func readyTapped(_ sender: Any) {
        configureState(option: true)
        if let comment = self.textView.text, textView.textColor != UIColor.darkGray {
            self.viewModel.getFixedComment(comment: comment, completion: { (comments) in
                if let comments = comments{
                    self.viewModel.writeComment(comments: comments,initialComment: comment)
                    DispatchQueue.main.async {
                        self.configureState(option: false)
                        self.goBack(left: TIME_PERIOD)
                    }
                } else {
                    
                    //
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: ALERT_TITLE, message: ALERT_MSG, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: ALERT_ACTTITLE, style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        self.configureState(option: false)
                        return
                    }
                }
               
            })
        } else {
            self.viewModel.writeComment(comments: nil, initialComment: nil)
            DispatchQueue.main.async {
                self.configureState(option: false)
                self.goBack(left: TIME_PERIOD)
            }
        }
        
    }
    
    func configureState(option: Bool){
        if option {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            readyButton.isEnabled = false
            readyButton.alpha = 0.3
            //textView.isEditable = false
            textView.isUserInteractionEnabled = false
            hashtagView.isUserInteractionEnabled = false
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            readyButton.isEnabled = true
            readyButton.alpha = 1
            textView.isUserInteractionEnabled = true
            hashtagView.isUserInteractionEnabled = true
        }
    }
    
    
    
    func goBack(left: Int){
        self.textView.text = ""
        
        self.delegate?.fire(left: left, viewModel: self.viewModel.mainViewModel())
        self.navigationController?.popViewController(animated: true)
        //return
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
