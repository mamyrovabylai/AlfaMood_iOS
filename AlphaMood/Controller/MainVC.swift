//
//  ViewController.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/16/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import SmoothPicker

class MainVC: UIViewController, SmoothPickerViewDelegate, SmoothPickerViewDataSource {

    @IBOutlet weak var picker: SmoothPickerView!
    private var pickedIndex: Int!
    private var userID: String!
    
    private var views = [UIImageView]()
    private let images = ["neutral", "smile", "angry"]
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        
        for i in 0...2{
            let view = UIImageView(image: UIImage(named: images[i]))
            view.frame.size = CGSize(width: 180, height: 180)
            views.append(view)
        }
        
        picker.firstselectedItem = 1
        pickedIndex = 1
        
        if let id = getUserID() {
            self.userID = id
        } else {
            saveUserId()
        }
    }
    
    func didSelectItem(index: Int, view: UIView, pickerView: SmoothPickerView) {
        self.pickedIndex = index
    }
    
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return 3
    }
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        return views[index]
    }
    @IBAction func nextTapped(_ sender: Any) {
        let person = Person(userID: self.userID, pickedIndex: pickedIndex)
        performSegue(withIdentifier: "mainGoComment", sender: person)
    }
    
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

