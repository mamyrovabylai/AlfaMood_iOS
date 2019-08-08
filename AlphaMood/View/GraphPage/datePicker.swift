//
//  datePicker.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/6/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
protocol datePickerDelegate {
    func picked(date: Date?)
}
class datePicker: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    var delegate: datePickerDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func closeTapped(_ sender: Any) {
        self.removeFromSuperview()
        print("tapped")
    }
    
    @IBAction func selected(_ sender: Any) {
        delegate?.picked(date: datePicker.date)
        self.removeFromSuperview()
        
    }
    
    
}
