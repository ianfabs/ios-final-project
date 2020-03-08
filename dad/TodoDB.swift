//
//  TodoDB.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/7/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import UIKit
import SQLite

class TodoDB {
    
    var db: Connection;
    let todos = Table("todos");
    let id = Expression<Int64>("id");
    let title = Expression<String>("title");
    let details = Expression<String>("details");
    let tags = Expression<String>("tags");
    let due = Expression<Date?>("due");
    let area = Expression<String>("area");
    
    
    init() throws {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        self.db = try Connection("\(path)/db.sqlite3");
        
//        self.todos = Table("todos");
//        let id = Expression<Int64>("id");
//        let title = Expression<String>("title");
//        let details = Expression<String>("details");
//        let tags = Expression<String>("tags");
//        let due = Expression<Date>("due");
//        let area = Expression<String>("area");
        let userDefaults = UserDefaults.standard;
        let isConfigured = userDefaults.bool(forKey: "isConfigured");
        if (isConfigured == false) {
            try self.db.run(todos.create { t in
                t.column(self.id, primaryKey: .autoincrement)
                t.column(self.title)
                t.column(self.details)
                t.column(self.tags)
                t.column(self.due)
                t.column(self.area)
            });
            userDefaults.set(true, forKey: "isConfigured")
        }
        
    }
    
    func add(title: String, details: String, area: Area = .todo, tags: String = "", due: Date? = nil) throws -> Int64 {
        let insertItem = self.todos.insert(
            self.title <- title,
            self.details <- details,
            self.area <- area.rawValue,
            self.tags <- tags,
            self.due <- due
        );
        
        let rowId = try self.db.run(insertItem);
        
        return rowId
    }
    
    func get(id: Int64) -> Table {
        return self.todos.filter(self.id == id)
    }
    
    func get(area: Area) -> Table {
        return self.todos.filter(self.area == area.rawValue)
    }
    
    func remove(id: Int64) throws {
        try self.db.run(self.todos.filter(self.id == id).delete());
    }
    
//    func addItem(item: Item) throws {
//        let _ = try self.todos.insert(item);
//    }
}

enum Area : String, Codable {
    case todo = "todo"
    case in_progress = "in-progress"
    case done = "done"
}

class TodoItemView: UIView {
    
}

struct Item: Codable {
    var title: String
    var details: String
    var area: String
    var tags: String
    var due: Date?
}
