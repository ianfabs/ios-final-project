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
    var tasks: [Task] {
        get {
            return store.tasks.sorted { (a, b) -> Bool in
                return a.order > b.order;
            }
        }
    }
    
    @IBOutlet weak var toggle: UIButton!
    
    var toggleImageConfig: UIImage.Configuration!;
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        backItem.tintColor = .red
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        
        if segue.identifier == "EditorSegue" {
            let editorVC = segue.destination as! TaskEditorViewController;
            
            if let selectedTaskCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!;
                let selectedTask = self.tasks[indexPath.row];
                editorVC.task = selectedTask;
                editorVC.store = self.store;
            }
        } else if segue.identifier == "NewTask" {
            let editorVC = segue.destination as! TaskEditorViewController;
            editorVC.type = .create
            editorVC.store = self.store
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tableView = self.view as! UITableView;
        tableView.reloadData();
    }
    
    override func viewDidLoad() {
        setEditing(false, animated: false)
        toggleImageConfig = (toggle.currentImage?.configuration)!
        let tableView = self.view as! UITableView;
        tableView.reloadData();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        // Get corresponding item
        let item = tasks.filter { (t) -> Bool in
            return t.order == indexPath.row
        }[0];
        cell.id = item.id;
//        print("Table ID (\(indexPath.row)) SQL ID (\(item.id))")
        print("Order ID (\(item.order))")
        // Set values for cell
        cell.TitleLabel.text = item.title;
//        cell.TagsLabel.text = item.tags;
        cell.DetailsLabel.text = item.details;
        let formatter = DateFormatter();
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "🗓 MMMM dd, yyyy ⏰ HH:mm a";
        if (item.due == nil) {
            cell.DueByLabel.text = "No due date";
        } else {
            cell.DueByLabel.text = formatter.string(from: item.due!);
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedTask = tableView.cellForRow(at: indexPath) as! ItemTableViewCell;
            try! store.remove(id: deletedTask.id)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData();
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditorSegue", sender: self)
//    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        store.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    
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
    
}
