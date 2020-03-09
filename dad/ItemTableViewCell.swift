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
    @IBOutlet weak var TagsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.showsReorderControl = true
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if (self.isSelected) {
//            let editor = TaskEditorViewController();
//            editor.modalPresentationStyle = .fullScreen;
//            if TitleLabel.text != nil {
//                editor.titleInput.text = TitleLabel.text;
//            }
//            if DetailsLabel.text != nil {
//                editor.detailsInput.text = DetailsLabel.text;
//            }
//            let formatter = DateFormatter();
//            if (DueByLabel.text != nil && DueByLabel.text != "No due date") {
//                editor.dueInput.date = formatter.date(from: DueByLabel.text!)!
//            } else {
//                // Figure something out
//            }
//            if TagsLabel.text!.contains(",") {
//                editor.tags = TagsLabel.text!.split(separator: ",");
//            }
//        }
//        // Configure the view for the selected state
//    }

}
