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
    let db: Connection
    
    let todos = Table("todos")
    let id = Expression<Int>("id");
    let title = Expression<String>("title");
    let details = Expression<String>("details");
    let tags = Expression<String>("tags");
    let due = Expression<Date?>("due");
    let area = Expression<String>("area");
    let order = Expression<Int>("order");
    
    var tasks: [Task] {
        get {
            return todos.decode(db: self.db)
        }
    }
    
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
                t.column(order)
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
    
    func add(task: Task) throws -> Int64 {
        let insertItem = try self.todos.insert(task);
        
        let rowId = try self.db.run(insertItem);
        
        return rowId
    }
    
    
    func add(task: OTask) throws -> Int64 {
        let insertItem = try self.todos.insert(task);
        
        let rowId = try self.db.run(insertItem);
        
        return rowId
    }
    
    func get(_ id: Int) -> Table {
        return self.todos.filter(self.id == id)
    }
    
    func get(area: Area) -> Table {
        return self.todos.filter(self.area == area.rawValue)
    }
    
    func get(_ area: Area) -> Table {
        return self.todos.filter(self.area == area.rawValue)
    }
    
    func update(task: Task) -> Int {
        return try! db.run(
            todos.filter(self.id == task.id).update(task)
        )
    }
    
    func remove(id: Int) throws {
        let query = self.todos.filter(self.id == id).delete();
        print(query.template)
        let result = try? self.db.run(query);
    }
    
    func remove(order: Int) throws {
        try self.db.run(self.todos.filter(self.order == order).delete());
    }
    
    func move(fromSpot: Int, toSpot: Int) throws {
        if fromSpot == toSpot {
            return
        }
        print("Move element at position \(fromSpot) to position \(toSpot)")
        
        try db.transaction {
            let fromQ = todos.filter(self.order == fromSpot).update(
                self.order <- toSpot
            )
            
            let temp_query = todos.filter(self.order == toSpot);
            var temp: Task = temp_query.decode(db: db)[0];
            
            // Remove to spot
            try db.run(temp_query.delete())
            // First update from
            try db.run(fromQ);
            // Change the temp's spot to the from's spot
            temp.order = fromSpot;
            // Insert!
            try db.run(todos.insert(temp));
        }
    }
    
    /// Reorders tasks by decrementing their order by one, intended to repair order **AFTER** deletion of element at order 0
    func reorder() -> Int {
//        let tasks = todos.decode(db: db);
        //        return try! db.run(
        //            todos.update(self.order <- self.order.bindings[0].)
        //        )
        let q = todos.update(self.order -= 1);
        let r = try! db.run(q);
        /// Test Code
//        let q: [Task] = tasks.map{ t in
//            var x = t;
//            x.order -= 1
//            return x;
//        }
//        for t in q {
//            print(t.order)
//        }
        return r;
    }
    
    func reorder(_ table: Table =
        Table("todos")) -> Int {
        let q = table.update(self.order -= 1);
        return try! db.run(q);
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
    case todo
    case in_progress = "in-progress"
    case done
}

// Defines a Task
struct Task: Codable {
    let id: Int
    var title: String
    var details: String
    var area: String
    var tags: String
    var due: Date? = nil
    var order: Int
    
    init(id: Int,title: String, details: String, area: Area, due: Date? = nil, tags: String = "", order: Int) {
        self.title = title
        self.details = details
        self.area = area.rawValue
        self.due = due
        self.id = id;
        self.tags = tags
        self.order = order;
    }
}

class OTask: Codable {
    var id: Int?
    var title: String
    var details: String
    var area: String
    var tags: String
    var due: Date?
    var order: Int
    
    init(title: String, details: String, area: String, tags: String = "", due: Date? = nil, order: Int) {
        self.title = title
        self.details = details
        self.area = area
        self.due = due
        self.id = nil;
        self.tags = tags;
        self.order = order
    }
    
    init(title: String, details: String, area: Area, tags: String = "", due: Date? = nil, order: Int) {
        self.title = title
        self.details = details
        self.area = area.rawValue
        self.due = due
        self.id = nil;
        self.tags = tags;
        self.order = order
    }
    
    init(id: Int, title: String, details: String, area: String, tags: String = "", due: Date? = nil, order: Int) {
        self.id = id;
        self.title = title
        self.details = details
        self.area = area
        self.due = due
        self.tags = tags;
        self.order = order
    }
    
//    func as_task() -> Task {
//        return Task(id: id!, title: title, details: details, area: "todo")
//    }
}
