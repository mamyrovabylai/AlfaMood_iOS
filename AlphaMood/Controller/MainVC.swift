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
        
        checkAllowence()
       
        viewForLabel.layer.cornerRadius = 8
        buttonNext.layer.cornerRadius = 8
        
        
        
        for image in images{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            let imageView = UIImageView(image: UIImage(named: image))
            imageView.frame = CGRect(x: 40, y: 40, width: 120, height: 120)
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
        
        
        
    }
    
    
  
    func unableButton() {
        self.buttonNext.isEnabled = false
        self.buttonNext.alpha = 0.3
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
            if timeLeft < 1 {
                self.enableButton()
                timer.invalidate()
                return
            }
            let string = components.string(from: TimeInterval(timeLeft))
            self.timerLabel.text = "Осталось : \(string!)"
            timeLeft -= 1
        }.fire()
    }
    
    func checkAllowence() {
        unableButton()
        if let lastDate = UserDefaults.standard.object(forKey: "AlfaBankUserDate") as? Date {
            let startDate = Date()
            Person.getTimeFromServer { (date) in
                
                guard let currentDate = date else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Соединение прервано", message: "Убедитесь что вы подключены к интернету", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                    return
                }
                print(Date().timeIntervalSince(startDate))
                print("!!!!")
                
                
                if currentDate.timeIntervalSince(lastDate) > 59 {
                    DispatchQueue.main.async {
                        self.enableButton()
                    }
                }  else {
                    DispatchQueue.main.async {
                        self.fireTimer(left: Int(60 - Date().timeIntervalSince(lastDate)) )
                    }
                }
            }
            
        } else {
            self.enableButton()
        }
    }
    func doCheck(left: Int) {
        fireTimer(left: left)
        print(left)
    }
    
    
    @IBAction func swiped(_ sender: UISwipeGestureRecognizer) {
//        if sender.direction == .left {
//            picker.navigate(direction: .pervious)
//        } else if sender.direction == .right {
//            picker.navigate(direction: .next)
//        }
    }
    
    @IBAction func swipeTapped(_ sender: UIButton) {
        
        if sender.tag == 0{
            picker.navigate(direction: .pervious)
        } else {
            picker.navigate(direction: .next)
        }
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
        UserDefaults.standard.synchronize()
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

