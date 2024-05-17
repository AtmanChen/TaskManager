import ComposableArchitecture
import SwiftUI
import SidebarFeature
import TaskListFeature
import Model

@Reducer
public struct AppLogic {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared(.inMemory("selectedSection")) var selection: TaskSection?
    var sideBar = SidebarLogic.State()
    var taskList = TaskListLogic.State(title: "All", tasks: Task.examples())
    public init() {}
  }
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case taskList(TaskListLogic.Action)
    case sideBar(SidebarLogic.Action)
  }
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.sideBar, action: \.sideBar) {
      SidebarLogic()
    }
    Scope(state: \.taskList, action: \.taskList) {
      TaskListLogic()
    }
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .taskList:
        return .none
      case .sideBar:
        return .none
      }
    }
  }
}

public struct AppView: View {
  @Bindable var store: StoreOf<AppLogic>
  public init(store: StoreOf<AppLogic>) {
    self.store = store
  }
  public var body: some View {
    NavigationSplitView {
      SidebarView(
        store: store.scope(state: \.sideBar, action: \.sideBar)
      )
    } detail: {
      switch store.selection {
      case .none: ContentUnavailableView("Please select a section", systemImage: "filemenu.and.selection")
      default: TaskListView(store: store.scope(state: \.taskList, action: \.taskList))
      }
    }

  }
}
