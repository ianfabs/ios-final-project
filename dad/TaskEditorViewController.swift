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
    var task: Task?
    var type: EditorType = .update;
    
    var currentTask : OTask {
        get {
            return OTask(
                title: titleInput.text!,
                details: detailsInput.text!,
                area: statusInput!.value,
                due: dueInput.date,
                order: 0
            )
        }
    }
    
    var areInputsValid: Bool {
        get {
            let titleIsValid = titleInput.text != nil || titleInput.text != "";
            let detailIsValid = detailsInput.text != nil || detailsInput.text != "";
            
             return titleIsValid && detailIsValid;
        }
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Add border to text area
        detailsInput.layer.borderColor = UIColor.opaqueSeparator.cgColor;
        detailsInput.layer.borderWidth = 1
        detailsInput.layer.cornerRadius = 5;
        
        if let task = task {
            titleInput.text = task.title;
            detailsInput.text = task.details;
            if let due = task.due {
                dueInput.date = due;
            }
            statusInput.value = Area(rawValue: task.area)!;
        }
        
        // Change labels based on type
        if type == .create {
            self.title = "New Task"
            saveBtn.title = "Create"
        } else {
            saveBtn.title = "Save"
            self.title = "Edit Task"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
        super.touchesBegan(touches, with: event);
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if type == .update {
            if let id = task?.id {
                updateTask(id);
            } else {
                print("bad task id 👎")
            }
        } else if type == .create {
            if self.areInputsValid {
                newTask();
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func newTask() {
        do {
            if let max = try! store.db.scalar(store.todos.select(store.order.max)) {
                currentTask.order = max;
            } else {
                currentTask.order = store.count(store.todos) - 1
            }
            let id = try store.add(task: currentTask)
            print("Success! New Task ID => \(id)")
        } catch let error {
            print(error.localizedDescription);
        }
    }
    
    func updateTask(_ id: Int) {
        do {
            try store.db.run(
                store.get(task!.id).update(currentTask)
            );
        } catch let error {
            print(error.localizedDescription);
        }
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

enum EditorType {
    case create, update
}
