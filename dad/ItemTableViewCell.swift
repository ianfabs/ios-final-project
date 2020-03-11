//
//  ItemTableViewCell.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DetailsLabel: UILabel!
    @IBOutlet weak var DueByLabel: UILabel!
    var task: Task! {
        didSet {
            TitleLabel.text = task.title
            DetailsLabel.text = task.details
            let fmt = DateFormatter();
            fmt.dateFormat = "yyyy-MM-dd hh:mm:ss"
            if let due = task.due {
                DueByLabel.text = fmt.string(from: due)
            } else {
                DueByLabel.text = "No due date"
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.showsReorderControl = true;
    }
    
}
