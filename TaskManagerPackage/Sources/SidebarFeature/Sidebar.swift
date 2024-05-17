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
public struct SidebarLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
    var userCreatedGroups: IdentifiedArrayOf<TaskGroup> = .init(uniqueElements: TaskGroup.examples())
    @Shared(.inMemory("selectedSection")) var selection: TaskSection?
  }

  public enum Action: BindableAction {
    case addNewGroup(TaskGroup)
    case binding(BindingAction<State>)
    case deleteGroupButtonTapped(id: UUID)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .addNewGroup(group):
        state.userCreatedGroups.append(group)
        return .none

      case .binding:
        return .none

      case let .deleteGroupButtonTapped(id):
        state.userCreatedGroups.remove(id: id)
        return .none
      }
    }
  }
}

public struct SidebarView: View {
  @Bindable var store: StoreOf<SidebarLogic>
  public init(store: StoreOf<SidebarLogic>) {
    self.store = store
  }

  public var body: some View {
    List(selection: $store.selection) {
      Section("Favorites") {
        ForEach(TaskSection.allCases) { selection in
          Label(selection.displayName, systemImage: selection.iconName)
            .tag(selection)
        }
      }
      Section("Your Groups") {
        ForEach($store.userCreatedGroups) { $group in
          HStack {
            Image(systemName: "folder")
            TextField("New Group", text: $group.title)
          }
          .tag(TaskSection.list(group))
          .contextMenu {
            Button("Delete", role: .destructive) {
              store.send(.deleteGroupButtonTapped(id: group.id))
            }
          }
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      Button {
        let newGroup = TaskGroup(title: "New Group")
        store.send(.addNewGroup(newGroup))
      } label: {
        Label("Add Group", systemImage: "plus.circle")
      }
      .buttonStyle(.borderless)
      .foregroundColor(.accentColor)
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(.thickMaterial)
      .keyboardShortcut(KeyEquivalent("a"), modifiers:  .command)
    }
  }
}
