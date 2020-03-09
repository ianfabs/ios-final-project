//
//  TaskEditorViewController.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit
import QuartzCore
import SQLite

class TaskEditorViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var detailsInput: UITextView!
    @IBOutlet weak var dueInput: UIDatePicker!
    @IBOutlet weak var statusInput: UIStatusControl!
    @IBOutlet weak var newTagInput: UITextField!
    @IBOutlet weak var tagCollection: UICollectionView!
    
    var store: TaskStore!
    var task: Task!
    
    var currentTask : Task {
        get {
            return Task(
                id: task.id,
                title: titleInput.text!,
                details: detailsInput.text!,
                area: statusInput!.value.rawValue,
                tags: "",
                due: dueInput.date
            )
        }
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        detailsInput.layer.borderColor = UIColor.opaqueSeparator.cgColor;
        detailsInput.layer.borderWidth = 1
        detailsInput.layer.cornerRadius = 5;
        
        if let task = task {
            titleInput.text = task.title;
            detailsInput.text = task.details;
            if let due = task.due {
                dueInput.date = due;
            }
            switch task.area {
                case "todo":
                    statusInput.selectedSegmentIndex = 0
                case "in-progress":
                    statusInput.selectedSegmentIndex = 1
                case "done":
                    statusInput.selectedSegmentIndex = 2
                default:
                    statusInput.selectedSegmentIndex = 0
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
        super.touchesBegan(touches, with: event);
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        do {
            try store.db.run(
                store.get(currentTask.id).update(currentTask)
            );
        } catch let error {
            print(error.localizedDescription);
        }
        self.navigationController?.popViewController(animated: true)
    }
}


class UIStatusControl : UISegmentedControl {
    var value: Area {
        get {
            // Would removing this first if-block make more sense? Ask conway, kyle and kyle later
            if selectedSegmentIndex == 0 {
                return .todo
            } else if selectedSegmentIndex == 1 {
                return .in_progress
            } else if selectedSegmentIndex == 2 {
                return .done
            } else {
                return .todo
            }
        }
        set {
            if newValue == .todo {
                selectedSegmentIndex = 0
            } else if newValue == .in_progress {
                selectedSegmentIndex = 1
            } else if newValue == .done {
                selectedSegmentIndex = 2
            } else {
                selectedSegmentIndex = 0
            }
        }
    }
}
