//
//  TaskStore.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/8/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import SQLite
import UIKit

class TaskStore {
    var tasks: [Task] = [];
    let db: Connection
    
    let todos = Table("todos")
    let id = Expression<Int64>("id");
    let title = Expression<String>("title");
    let details = Expression<String>("details");
    let tags = Expression<String>("tags");
    let due = Expression<Date?>("due");
    let area = Expression<String>("area");
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        self.db = try! Connection("\(path)/db.sqlite3");
        
        let userDefaults = UserDefaults.standard;
        let isConfigured = userDefaults.bool(forKey: "isConfigured");
        if (isConfigured == false) {
            try! self.db.run(todos.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                t.column(details)
                t.column(tags)
                t.column(due)
                t.column(area)
            });
            userDefaults.set(true, forKey: "isConfigured")
        } else {
            self.tasks = try! db.prepare(self.get(area: .todo)).map { row in
                return try! row.decode()
            }
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
    
    func get(_ id: Int) -> Table {
        return self.todos.filter(self.id == Int64.init(exactly: id)!)
    }
    
    func get(area: Area) -> Table {
        return self.todos.filter(self.area == area.rawValue)
    }
    
    func get(_ area: Area) -> Table {
        return self.todos.filter(self.area == area.rawValue)
    }
    
    func remove(id: Int64) throws {
        try self.db.run(self.todos.filter(self.id == id).delete());
    }
}

// This should make for easier on-the-fly decoding
// For example:
// ```
// let store = TaskStore()
// let tasksInProgress = store.get(area: .in_progress).decode();
// ```
extension Table {
    func decode(db: Connection) -> [Task] {
        return try! db.prepare(self).map{ row in
            return try row.decode()
        }
    }
}

// Defines the possible values for task areas
enum Area : String, Codable {
    case todo = "todo"
    case in_progress = "in-progress"
    case done = "done"
}

// Defines a Task
struct Task: Codable {
    let id: Int
    var title: String
    var details: String
    var area: String
    var tags: String
    var due: Date?
}
