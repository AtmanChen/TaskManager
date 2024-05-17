//
//  File.swift
//  
//
//  Created by lambert on 2024/5/17.
//

import ComposableArchitecture
import Model
import SwiftUI

@Reducer
public struct TaskLogic {
  public init() {}
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public init(
      task: Task,
      selectedTask: Shared<Task?>,
      inspectorIsShown: Shared<Bool>
    ) {
      self.task = task
      self._selectedTask = selectedTask
      self._inspectorIsShown = inspectorIsShown
    }
    var task: Task
    @Shared var selectedTask: Task?
    @Shared var inspectorIsShown: Bool
    public var id: UUID { task.id }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case moreButtonDidTapped
    case toggleTaskCompleted
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .moreButtonDidTapped:
        state.selectedTask = state.task
        state.inspectorIsShown = true
        return .none
        
      case .toggleTaskCompleted:
        state.task.isCompleted.toggle()
        return .none
      }
    }
  }
}

public struct TaskView: View {
  @Bindable var store: StoreOf<TaskLogic>
  public init(store: StoreOf<TaskLogic>) {
    self.store = store
  }
  public var body: some View {
    HStack {
      Image(systemName: store.task.isCompleted ? "largecircle.fill.circle" : "circle")
        .onTapGesture {
          store.send(.toggleTaskCompleted)
        }
      TextField("New Task", text: $store.task.title)
        .textFieldStyle(.plain)
      
      Button {
        store.send(.moreButtonDidTapped)
      } label: {
        Text("More")
      }
    }
  }
}
