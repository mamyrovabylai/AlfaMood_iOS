//
//  GraphViewController.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/2/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit
import Macaw
class GraphViewController: UIViewController {


    @IBOutlet weak var chooseDateBtn: UIButton!
    @IBOutlet weak var lineView: LineView!
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        play(withDelay: 1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lineView.removeListener()
    }
    
    private func play(withDelay: TimeInterval) {
        self.perform(#selector(animateViews), with: .none, afterDelay: withDelay)
    }
    
    @objc open func animateViews() {
        lineView.viewModel = GraphViewModel(date: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineView.backgroundColor = UIColor(cgColor: Color(val: BACK_CLR_INT).toCG())
        chooseDateBtn.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor(cgColor: Color(val: BACK_CLR_INT).toCG())
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        
        let nib = Bundle.main.loadNibNamed(DATEPICKER_NIBNAME, owner: self, options: nil)!.first as! datePicker
        self.view.addSubview(nib)
        nib.delegate = self
        nib.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
        nib.frame.size.width = self.view.frame.width
        nib.frame.size.height = 200
       // nib.closeButton.isEnabled = true
        
        UIView.animate(withDuration: 0.5) {
            nib.frame.origin.y = self.view.frame.height - nib.frame.height - (self.tabBarController?.tabBar.frame.size.height)!
        }
        
    }
    


}

extension GraphViewController: datePickerDelegate{
    func picked(date: Date?) {
        if let date = date{
            lineView.viewModel.date = date
            print(date)
            lineView.getMoodsInView()
        }
    }
}
