//
//  TaskEditorViewController.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit

class TaskEditorViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var detailsInput: UITextView!
    @IBOutlet weak var dueInput: UIDatePicker!
    @IBOutlet weak var statusInput: UISegmentedControl!
    @IBOutlet weak var newTagInput: UITextField!
    @IBOutlet weak var tagCollection: UICollectionView!
    var tags: [String.SubSequence] = [];
    
    
    override func viewDidLoad() {
        detailsInput.layer.borderColor = titleInput.layer.borderColor
        detailsInput.layer.borderWidth = titleInput.layer.borderWidth
    }
}
