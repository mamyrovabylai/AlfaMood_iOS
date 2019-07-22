//
//  ViewController.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/16/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import SmoothPicker

class MainVC: UIViewController, CommentDelegate{
    
    

    
    //Outlets
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var picker: SmoothPickerView!
    @IBOutlet weak var buttonNext: UIButton!
    var person: Person!
    
    //Variables
    private var views = [UIView]()
    private let images = [NAME_IMG_NEUTRAL, NAME_IMG_POSITIVE, NAME_IMG_NEGATIVE]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        viewForLabel.layer.cornerRadius = 8
        buttonNext.layer.cornerRadius = 8
        
        for image in images{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
            let imageView = UIImageView(image: UIImage(named: image))
            imageView.frame = CGRect(x: 40, y: 40, width: 160, height: 160)
            view.addSubview(imageView)
            views.append(view)
        }
        
        picker.firstselectedItem = 1
        picker.dataSource = self
        picker.delegate = self
        
        if let id = getUserID() {
            self.person = Person(userID: id, pickedIndex: 1)
        } else {
            self.person = Person(userID: saveUserId(), pickedIndex: 1)
        }
        
         checkAllowence()
        
    }
    
    
  
    func unableButton() {
        self.buttonNext.isEnabled = false
        self.buttonNext.alpha = 0.3
        self.timerLabel.text = "Осталось : X"
    }
    func enableButton() {
        self.buttonNext.isEnabled = true
        self.buttonNext.alpha = 1
        self.timerLabel.text = ""
    }
    
    func fireTimer(left: Int){
        unableButton()
        let components = DateComponentsFormatter()
        components.allowedUnits = [.hour, .minute, .second]
        components.unitsStyle = .full
        var timeLeft = left
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if timeLeft == 0 {
                self.enableButton()
                timer.invalidate()
            }
            let string = components.string(from: TimeInterval(timeLeft))
            self.timerLabel.text = "Осталось : \(string!)"
            timeLeft -= 1
        }
    }
    
    func checkAllowence() {
        self.unableButton()
        person.isWriteAllowed { (allowed, left) in
            if !allowed {
                self.fireTimer(left: left)
            } else {
                self.enableButton()
            }
        }
    }
    func doCheck(left: Int) {
        fireTimer(left: left)
        print(left)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "mainGoComment", sender: self.person)
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainGoComment", let destination = segue.destination as? CommentVC {
            if let person = sender as? Person {
                destination.person = person
            } else {
                print("!!!Can not trnsfer person to the CommentVC")
            }
            destination.delegate = self
            
        }
    }

}

// User Defaults
extension MainVC {
    func saveUserId() -> String{
        let userID = UUID().uuidString
        UserDefaults.standard.set(userID, forKey: "AlfaBankUserID")
        return userID
        
    }
    func getUserID() -> String?{
        if let userID = UserDefaults.standard.string(forKey: "AlfaBankUserID") {
            return userID
            
        } else {
            return nil
        }
    }
}

// Smooth Picker View's data source and delegate protocols
extension MainVC: SmoothPickerViewDataSource, SmoothPickerViewDelegate{
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return views.count
    }
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        return views[index]
    }
    
    func didSelectItem(index: Int, view: UIView, pickerView: SmoothPickerView) {
        self.person.changePickedIndex(index: index)
    }
}

