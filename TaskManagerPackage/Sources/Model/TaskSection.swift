//
//  TaskSection.swift
//  TaskManager
//
//  Created by Karin Prater on 21.08.2023.
//

import Foundation

public enum TaskSection: Identifiable, CaseIterable, Hashable {
  case all
  case done
  case upcoming
  case list(TaskGroup)
    
  public var id: String {
    switch self {
      case .all:
        "all"
      case .done:
        "done"
      case .upcoming:
        "upcoming"
      case .list(let taskGroup):
        taskGroup.id.uuidString
    }
  }
    
  public var displayName: String {
    switch self {
      case .all:
        "All"
      case .done:
        "Done"
      case .upcoming:
        "Upcoming"
      case .list(let taskGroup):
        taskGroup.title
    }
  }
    
  public var iconName: String {
    switch self {
      case .all:
        "star"
      case .done:
        "checkmark.circle"
      case .upcoming:
        "calendar"
      case .list:
        "folder"
    }
  }
    
  public static var allCases: [TaskSection] {
    [.all, .done, .upcoming]
  }
    
  public static func == (lhs: TaskSection, rhs: TaskSection) -> Bool {
    lhs.id == rhs.id
  }
    
  public static var initialValue: TaskSection? {
    #if os(macOS)
    TaskSection.all
    #else
    nil
    #endif
  }
}
