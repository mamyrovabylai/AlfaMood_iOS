//
//  PinCodeVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 7/26/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
class PinCodeVC: UIViewController, ButtonViewDelegate  {

    @IBOutlet weak var buttonView: ButtonView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        buttonView.delegate = self

        // Do any additional setup after loading the view.
    }
    func buttonTapped(number: String) {
        print(number)
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


