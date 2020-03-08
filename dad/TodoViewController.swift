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
    let store = try! TodoDB();
    
    var itemsTodo: [Item] = [];
    
    override func viewDidLoad() {
        // Load items
        itemsTodo = self.loadItems();
//        for todo in try! store.db.prepare(store.todos) {
//            print("id: \(todo[store.id]), title: \(todo[store.title]), details: \(todo[store.details])")
//            // id: 1, name: Optional("Alice"), email: alice@mac.com
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemsTodo = self.loadItems();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsTodo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        itemsTodo = self.loadItems();
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let item = itemsTodo[indexPath.row]
        
        cell.TitleLabel.text = item.title
        cell.TagsLabel.text = item.tags
        cell.DetailsLabel.text = item.details
//        cell.DetailsLabel.numberOfLines = 0;
//        cell.DetailsLabel.sizeToFit()
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "MMMM dd, yyyy HH:mm:ss"
        if (item.due == nil) {
            cell.DueByLabel.text = "No due date"
        } else {
            cell.DueByLabel.text = formatter.string(from: item.due!)
        }
        
        return cell
    }
    
    func loadItems() -> [Item] {
        return try! self.store.db.prepare(self.store.get(area: .todo)).map { row in
            return try row.decode()
        }
    }
    
}
