//
//  ViewController.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/16/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import SmoothPicker
import NotificationCenter


class MainVC: UIViewController, PinDelegate{
    
    var mainViewModel: MainViewModel = MainViewModel()
    
    func pinWillDismiss(viewModel: MainViewModel) {
        self.mainViewModel = viewModel
        print(mainViewModel.person.isPinned)
    }
    //Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var picker: SmoothPickerView!
    @IBOutlet weak var buttonNext: UIButton!
    var timer: Timer!
   
   
    
    //Variables
    private var views = [UIView]()
    private var images: [String]!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(checkTime), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(removeTimer), name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func removeTimer(){
        if timer != nil{
            self.timer.invalidate()
        }
    }
    @objc func checkTime(){
        unableButton()
        let granted = mainViewModel.checkAllowence()
        if granted.0{
            enableButton()
        } else {
            fireTimer(left: granted.1!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if user entered pass code
        if mainViewModel.isUserPinned() {
           self.performSegue(withIdentifier: "mainGoPinCode", sender: nil)
        }
        //Check if appropriate time is left from previous comment
       checkTime()
        // Configuration of Views
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        
        viewForLabel.layer.cornerRadius = 8
        buttonNext.layer.cornerRadius = 8
        
        for image in mainViewModel.imageNames{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            let imageView = UIImageView(image: UIImage(named: image))
            imageView.frame = CGRect(x: 40, y: 40, width: 120, height: 120)
            view.addSubview(imageView)
            views.append(view)
        }
        picker.firstselectedItem = 1
        picker.dataSource = self
        picker.isUserInteractionEnabled = false
    }
    
    @IBAction func swipeTapped(_ sender: UIButton) {
        if sender.tag == 0{
            picker.navigate(direction: .pervious)
        } else {
            picker.navigate(direction: .next)
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        performSegue(withIdentifier: "mainGoComment", sender: picker.currentSelectedIndex)
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
        var timeLeft = left
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if timeLeft < 1 {
                self.enableButton()
                timer.invalidate()
                return
            }
            let string = self.mainViewModel.getStringForTimer(left: timeLeft)
            self.timerLabel.text = "Осталось : \(string)"
            timeLeft -= 1
            }
        timer.fire()
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainGoComment", let destination = segue.destination as? CommentVC {
            if let index = sender as? Int {
                destination.viewModel = self.mainViewModel.secondPageViewModel(pickedIndex: index)!
            } else {
                print("!!!Can not trnsfer person to the CommentVC")
            }
            destination.delegate = self
            
        } else if segue.identifier == "mainGoPinCode", let destination = segue.destination as? PinCodeVC {
            destination.viewModel = self.mainViewModel.pinViewModel()
            destination.delegate = self
            
            
        }
    }

}


//Action after sending comment
extension MainVC: CommentDelegate {
    func fire(left: Int, viewModel: MainViewModel) {
        fireTimer(left: left)
        self.mainViewModel = viewModel
        print(mainViewModel.person.lastDate!)
    }
}

// Smooth Picker View's data source and delegate protocols
extension MainVC: SmoothPickerViewDataSource{
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return views.count
    }
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        return views[index]
    }

}

