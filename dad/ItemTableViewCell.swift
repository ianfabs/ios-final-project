//
//  ItemTableViewCell.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var TagsLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DetailsLabel: UITextView!
    @IBOutlet weak var DueByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (self.isSelected) {
            let editor = TaskEditorViewController();
            editor.modalPresentationStyle = .fullScreen;
            editor.titleInput.text = TitleLabel.text;
            editor.detailsInput.text = DetailsLabel.text;
            let formatter = DateFormatter();
            if (DueByLabel.text != "No due date") {
                editor.dueInput.date = formatter.date(from: DueByLabel.text!)!
            } else {
                // Figure something out
            }
            if TagsLabel.text!.contains(",") {
                editor.tags = TagsLabel.text!.split(separator: ",");
            }
            
        }
        // Configure the view for the selected state
    }

}
