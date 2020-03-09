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
    var tasks: [Task]!;
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        
        loadTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        loadTasks()
        if segue.identifier == "EditorSegue" {
            let editorVC = segue.destination as! TaskEditorViewController;
            
            if let selectedTaskCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!;
                let selectedTask = self.tasks[indexPath.row];
                editorVC.task = selectedTask;
                editorVC.store = self.store;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tableView = self.view as! UITableView;
        tableView.reloadData();
    }
    
    override func viewDidLoad() {
        loadTasks()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadTasks()
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        // Get corresponding item
        let item = store.get(.todo).decode(db: store.db)[indexPath.row];
        
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditorSegue", sender: self)
//    }
    
    func loadTasks() {
        tasks = store.get(.todo).decode(db: store.db)
    }
    
    
}
