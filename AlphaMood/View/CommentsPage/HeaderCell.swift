//
//  HeaderCell.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/1/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    var viewModel: HeaderViewModel! {
        didSet{
            commentLbl.text = viewModel.comment
            numLikesLbl.text = viewModel.numLikes
            let gesture = UITapGestureRecognizer(target: self, action: #selector(starTapped))
            img.addGestureRecognizer(gesture)
            img.isUserInteractionEnabled = true
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewModel.getNameForImage {
                self.img.image = UIImage(named: self.viewModel.imgName)
            }
            
        }
    }
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var numLikesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @objc func starTapped(){
        self.img.isUserInteractionEnabled = false
        viewModel.likeIt(){
            self.img.image = UIImage(named: self.viewModel.imgName)
            self.img.isUserInteractionEnabled = true
        }
    }

  

}
