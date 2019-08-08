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


class MainVC: UIViewController{
    
    var mainViewModel: MainViewModel = MainViewModel()
    
    //Outlets
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Unabling
        unableButton()
        configureTabs(option: false)
        mainViewModel.isUserLogged { (granted) in
            if granted {
                // Check if user entered pass code
                if  !self.mainViewModel.isUserPinned(){
                    self.performSegue(withIdentifier: SEGUE_PIN, sender: nil)
                }
                
                //Check if appropriate time is left from previous comment
                self.checkTime()
                // enabling tab bar
                self.configureTabs(option: true)
                
            } else {
                //Authorize new user
                self.mainViewModel.authorizeAnon {
                    self.performSegue(withIdentifier: SEGUE_PIN, sender: nil)
                }
            }
        }
        
        // Configuration of Views
        self.viewForLabel.layer.cornerRadius = 8
        self.buttonNext.layer.cornerRadius = 8
        for image in  [NAME_IMG_NEGATIVE, NAME_IMG_NEUTRAL, NAME_IMG_POSITIVE]{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            let imageView = UIImageView(image: UIImage(named: image))
            imageView.frame = CGRect(x: 40, y: 40, width: 120, height: 120)
            view.addSubview(imageView)
            self.views.append(view)
        }
        self.picker.firstselectedItem = 1
        self.picker.dataSource = self
        self.picker.isUserInteractionEnabled = false
        
        
    }
    
    @IBAction func swipeTapped(_ sender: UIButton) {
        if sender.tag == 0{
            picker.navigate(direction: .pervious)
        } else {
            picker.navigate(direction: .next)
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        performSegue(withIdentifier: SEGUE_COMMENT, sender: picker.currentSelectedIndex)
    }
    
    func configureTabs(option: Bool){
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            for tab in tabArray{
                tab.isEnabled = option
            }
        }
        
        if !option {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
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
        var timeLeft = left
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if timeLeft < 1 {
                self.enableButton()
                timer.invalidate()
                return
            }
            let string = self.mainViewModel.getStringForTimer(left: timeLeft)
            self.timerLabel.text = "Доступно через : \(string)"
            timeLeft -= 1
            }
        timer.fire()
    }
    
    @objc func checkTime(){
        unableButton()
        let granted = mainViewModel.checkAllowence()
        if granted.0{
            enableButton()
        } else {
            if granted.1 != 0 {
                fireTimer(left: granted.1!)
            }
        }
    }
    
    @objc func removeTimer(){
        if timer != nil{
            self.timer.invalidate()
        }
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_COMMENT, let destination = segue.destination as? CommentVC {
            if let index = sender as? Int {
                destination.viewModel = self.mainViewModel.secondPageViewModel(pickedIndex: index)!
            }
            destination.delegate = self
        } else if segue.identifier == SEGUE_PIN, let destination = segue.destination as? PinCodeVC {
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
    }
    
    
}

extension MainVC: PinDelegate {
    func pinWillDismiss(viewModel: MainViewModel) {
        self.mainViewModel = viewModel
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

