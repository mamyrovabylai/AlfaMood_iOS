//
//  CommentsVC.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/1/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CommentsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CommentsViewModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = CGFloat(HEIGHT_CELL)
        tableView.estimatedSectionHeaderHeight = CGFloat(HEIGHT_HEADER)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.removeListener()
        viewModel.getComments {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeListener()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.changeMood(mood: MoodModel(rawValue: sender.selectedSegmentIndex)!)
        viewModel.getComments {
            self.tableView.reloadData()
        }
    }

    // Table View Configuration
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.comments.count == 0{
            let message = NO_COMMENTS
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = message
            messageLabel.textColor = UIColor.white
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: FONT_GRAPH, size: 15)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
        } else {
            tableView.backgroundView = nil
        }
        return viewModel.comments.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.initialComments[section]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DEQUEUE_CELL) as? CommentCell{
            cell.viewModel = viewModel.cellViewModel(hIndex: indexPath.section, cIndex: indexPath.row)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: DEQUEUE_HEADER) as! HeaderCell
        header.viewModel = viewModel.headerViewModel(index: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}
