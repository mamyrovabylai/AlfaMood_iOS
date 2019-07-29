//
//  PinCodeVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/26/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
class PinCodeVC: UIViewController {

    @IBOutlet weak var circle1: CircleView!
    
    @IBOutlet weak var circle2: CircleView!
    @IBOutlet weak var circle3: CircleView!
    
    @IBOutlet weak var circle4: CircleView!
    
    var circles = [CircleView]()
    var counter = 0
    var pin = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        circles.append(contentsOf: [circle1,circle2,circle3,circle4])
    }
    

    @IBAction func numberButtonTapped(_ sender: NumberButton) {
        
        circles[counter].drawShape(with: .lightGray)
        pin.append(sender.tag)
        counter += 1
        
        if counter == 4 {
            let rightPassword = "1234"
            var rightPass = [Int]()
            rightPassword.forEach { (char) in
                rightPass.append(Int(String(char))!)
            }
            
            if rightPass == pin {
                UserDef.UserPinned(mode: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                circles.forEach { (circle) in
                    circle.drawShape(with: .clear)
                }
                counter = 0
                pin = []
                let alert = UIAlertController(title: "Пароль", message: "Неправильный пароль", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        if counter > 0 {
            circles[counter-1].drawShape(with: .clear)
            pin.remove(at: counter-1)
            
            counter -= 1
            
        }
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


