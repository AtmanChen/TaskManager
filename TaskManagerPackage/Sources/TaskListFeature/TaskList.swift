//
//  File.swift
//  
//
//  Created by lambert on 2024/5/17.
//

import ComposableArchitecture
import Model
import SwiftUI
import TaskFeature

@Reducer
public struct TaskListLogic {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init(title: String, tasks: [Task]) {
      self.title = title
//      self.tasks = .init(uniqueElements: tasks.map { TaskLogic.State(task: $0, selectedTask: $selectedTask, inspectorIsShown: $inspectorIsShown) })
      self.tasks = .init(uniqueElements: tasks)
    }
    var title: String
    var tasks: IdentifiedArrayOf<Task>
    @Shared(.inMemory("selectedTask")) var selectedTask: Task?
    @Shared(.inMemory("inspectorIsShown")) var inspectorIsShown = false
  }
  
  public enum Action: BindableAction {
    case addNewTaskButtonTapped
    case binding(BindingAction<State>)
    case toggleInspector
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .addNewTaskButtonTapped:
        return .none
        
      case .binding:
        return .none
        
      case .toggleInspector:
        state.inspectorIsShown.toggle()
        return .none
      }
    }
  }
}

public struct TaskListView: View {
  @Bindable var store: StoreOf<TaskListLogic>
  public init(store: StoreOf<TaskListLogic>) {
    self.store = store
  }
  public var body: some View {
    List {
      ForEach(store.tasks) { task in
        TaskView(
          store: Store(
            initialState: TaskLogic.State(task: task, selectedTask: store.$selectedTask, inspectorIsShown: store.$inspectorIsShown),
            reducer: TaskLogic.init
          )
        )
      }
    }
    .navigationTitle(store.title)
    .toolbar {
      ToolbarItemGroup {
        Button {
          store.send(.addNewTaskButtonTapped)
        } label: {
          Label("Add New Task", systemImage: "plus")
        }
        Button {
          store.send(.toggleInspector)
        } label: {
          Label("Show inspector", systemImage: "sidebar.right")
        }
      }
    }
    .inspector(isPresented: $store.inspectorIsShown) {
      Group {
        if let selectedTask = store.selectedTask {
            Text(selectedTask.title).font(.title)
        } else {
            Text("nothing selected")
        }
      }
    }
    .frame(minWidth: 100, maxWidth: .infinity)
  }
}
