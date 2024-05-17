//
//  TaskGroup.swift
//  TaskManager
//
//  Created by Karin Prater on 21.08.2023.
//

import Foundation

public struct TaskGroup: Equatable, Identifiable, Hashable {
  public let id = UUID()
  public var title: String
  public let creationDate: Date
  public var tasks: [Task]
    
  public init(title: String, tasks: [Task] = []) {
    self.title = title
    self.creationDate = Date()
    self.tasks = tasks
  }
    
  public static func example() -> TaskGroup {
    let task1 = Task(title: "Buy groceries")
    let task2 = Task(title: "Finish project")
    let task3 = Task(title: "Call dentist")
        
    var group = TaskGroup(title: "Personal")
    group.tasks = [task1, task2, task3]
    return group
  }
    
  public static func examples() -> [TaskGroup] {
    let group1 = TaskGroup.example()
    let group2 = TaskGroup(title: "New list")
    return [group1, group2]
  }
}
