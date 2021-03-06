//
//  TodoViewController.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit
import SQLite

class TodoViewController : UITableViewController {
    var store = TaskStore();
    
    @IBOutlet weak var toggle: UIButton!
    
    var toggleImageConfig: UIImage.Configuration!;
    
    var count: Int {
        get {
            var rowCount = 0;
            for index in 0...tableView.numberOfSections {
                rowCount += tableView.numberOfRows(inSection: index)
            }
            return rowCount
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        print("All Todos 👉")
        if let tasks = store.get(1).decode(db: store.db) {
            for task in tasks {
                print("ID \(task.id)")
                print("Order \(task.order)")
            }
        } else {
            print("No tasks :-(")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        backItem.tintColor = .red
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        
        // MARK: - Prepare for segue named "EditorSegue" -
        if segue.identifier == "EditorSegue" {
            let editorVC = segue.destination as! TaskEditorViewController;
            
            if let selectedTaskCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!;
                editorVC.store = self.store;
                if let tasks = store.get(order: indexPath.row).decode(db: store.db) {
                    let task = tasks[0]
                    editorVC.task = task;
                } else {
                    debugPrint(SQLError.DecodeFailed)
                }
            }
            
        // MARK: - Prepare for segue named "NewTask" -
        } else if segue.identifier == "NewTask" {
            let editorVC = segue.destination as! TaskEditorViewController;
            editorVC.type = .create
//            editorVC.store = self.store
            
        } else {
            debugPrint(SceneError.Segue, "Segue did not match any implemented segues")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData();
    }
    
    override func viewDidLoad() {
        setEditing(false, animated: false)
        isEditing = false
        toggleImageConfig = (toggle.currentImage?.configuration)!
        tableView.reloadData();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count(store.get(.todo))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        // Get corresponding item
        if let items = store.get(order: indexPath.row).sort(store.order.asc).decode(db: store.db) {
            debugPrint("Number of Items =>", items.count)
            if items.count == 1 {
                let item = items[0];
                debugPrint("Inserting task #\(item.id) into table row #\(indexPath.row)")
                cell.task = item;
            } else if items.count > 1 {
                debugPrint(AppError.TooManyTasks)
            } else {
                debugPrint(AppError.NoTasks)
            }
        } else {
            debugPrint(AppError.NoTasks, "\n Could not get task by row")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedTask = tableView.cellForRow(at: indexPath) as! ItemTableViewCell;
            debugPrint("Task object for selected row =>\n", deletedTask.task!)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if deletedTask.task.id == indexPath.row {
                //TODO: Make sure "self.count" works
                if indexPath.row == 0 && self.count > 1 {
                    store.reorder()
                }
                // MARK: 🚫 SQLite removal disabled for testing 🚫
//                try! store.remove(id: deletedTask.task.id)
            }
        }
        tableView.reloadData();
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditorSegue", sender: self)
//    }
    
    // MARK: -Move Table Item-
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
//        store.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        // if row index == 0 update all tasks so that order = order-1
        tableView.reloadData()
    }
    
    // MARK: - IBActions -
    // MARK: toggle editing
    @IBAction func enableEditingTaskList(_ sender: UIButton, forEvent event: UIEvent) {
        let on = UIImage.init(systemName: "rectangle.grid.1x2.fill", withConfiguration: toggleImageConfig);
        let off = UIImage.init(systemName: "rectangle.grid.1x2", withConfiguration: toggleImageConfig);
        
        print("is editing => \(isEditing)")
        if isEditing == true {
            toggle.setImage(off, for: .normal)
            setEditing(false, animated: true)
        } else {
            toggle.setImage(on, for: .normal)
            setEditing(true, animated: true)
        }
        print("is editing => \(isEditing)")
        tableView.reloadData();
    }
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        try! store.db.run(store.todos.delete())
        tableView.reloadData()
    }
    
    
}
