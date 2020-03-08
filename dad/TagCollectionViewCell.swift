//
//  TagCollectionViewCell.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var CloseButton: UIButton!
    
    static func new(label: String) -> TagCollectionViewCell {
        let me = TagCollectionViewCell();
        me.Label.text = label;
        return me;
    }
}
