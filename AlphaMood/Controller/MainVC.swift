//
//  ViewController.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/16/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import SmoothPicker

class MainVC: UIViewController {

    
    //Outlets
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var picker: SmoothPickerView!
    @IBOutlet weak var buttonNext: UIButton!
    
    //Variables
    private var userID: String!
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
        
        if let id = getUserID() {
            self.userID = id
        } else {
            saveUserId()
        }
    }
  
    
    
    
    @IBAction func nextTapped(_ sender: Any) {
        let person = Person(userID: self.userID, pickedIndex: picker.currentSelectedIndex)
        performSegue(withIdentifier: "mainGoComment", sender: person)
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainGoComment", let destination = segue.destination as? CommentVC {
            if let person = sender as? Person {
                destination.person = person
            } else {
                print("!!!Can not trnsfer person to the CommentVC")
            }
            
        }
    }

}

// User Defaults
extension MainVC {
    func saveUserId(){
        let userID = UUID().uuidString
        self.userID = userID
        UserDefaults.standard.set(userID, forKey: "AlfaBankUserID")
        
    }
    func getUserID() -> String?{
        if let userID = UserDefaults.standard.string(forKey: "AlfaBankUserID") {
            return userID
            
        } else {
            return nil
        }
    }
}

// Smooth Picker View's data source
extension MainVC: SmoothPickerViewDataSource{
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return views.count
    }
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        return views[index]
    }
}

