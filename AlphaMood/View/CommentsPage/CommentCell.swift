//
//  CommentCell.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/1/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

 
    @IBOutlet weak var initialCommentLbl: UILabel!
   
    var viewModel: CommentCellViewModel! {
        didSet {
            self.initialCommentLbl.text = viewModel.initialComment
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
