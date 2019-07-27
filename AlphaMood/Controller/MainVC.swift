//
//  ViewController.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/16/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import SmoothPicker

class MainVC: UIViewController{
    
    //Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var picker: SmoothPickerView!
    @IBOutlet weak var buttonNext: UIButton!
    var person: Person!
    var userDef: UserDef = UserDef()
    
    //Variables
    private var views = [UIView]()
    private let images = [NAME_IMG_NEUTRAL, NAME_IMG_POSITIVE, NAME_IMG_NEGATIVE]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDef.savePin(pin: "1234")
        if !UserDef.getUserPinned() {
            self.performSegue(withIdentifier: "mainGoPinCode", sender: nil)
        }
        
        //
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        
        
        userDef.delegate = self
        userDef.checkAllowence( buttonNext: buttonNext, timerLabel: timerLabel)
        
        self.person = UserDef.createPerson()
       
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
extension MainVC: UserDefProtocol {
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func checkAgain() {
        userDef.checkAllowence( buttonNext: buttonNext, timerLabel: timerLabel)
    }
}
//Action after sending comment
extension MainVC: CommentDelegate {
    func doCheck(left: Int) {
        UserDef.fireTimer(left: left, buttonNext: buttonNext, timerLabel: timerLabel)
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

