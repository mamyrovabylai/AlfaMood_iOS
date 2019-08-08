//
//  PinCodeVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/26/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit

protocol PinDelegate {
    func pinWillDismiss(viewModel: MainViewModel)
}
class PinCodeVC: UIViewController {
    
    var viewModel: PinViewModel!
    
    var delegate: PinDelegate?

    @IBOutlet weak var circle1: CircleView!
    @IBOutlet weak var circle2: CircleView!
    @IBOutlet weak var circle3: CircleView!
    @IBOutlet weak var circle4: CircleView!
    
    var circles = [CircleView]()
    var counter = 0
    var pin = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circles.append(contentsOf: [circle1,circle2,circle3,circle4])
    }
    

    @IBAction func numberButtonTapped(_ sender: NumberButton) {
        
        
        circles[counter].drawShape(with: .lightGray)
        pin.append(sender.tag)
        counter += 1
        
        if counter == 4 {
            self.view.isUserInteractionEnabled = false
            
            viewModel.getPin { (rightPassword) in
                if rightPassword == self.pin {
                    self.viewModel.pinUser()
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.pinWillDismiss(viewModel: self.viewModel.mainViewModel())
                    
                } else {
                    self.circles.forEach { (circle) in
                        circle.drawShape(with: .clear)
                    }
                    self.view.isUserInteractionEnabled = true
                    self.counter = 0
                    self.pin = []
                    let alert = UIAlertController(title: PINALERT_TITLE, message: PINALERT_MSG, preferredStyle: .alert )
                    alert.addAction(UIAlertAction(title: PINALERT_ACTTITLE, style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
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
}


