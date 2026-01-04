//
//  AppFeature.swift
//  AppStore
//
//  Created by Langpeu on 1/4/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
  @ObservableState
  struct State {
    var search = SearchFeature.State()
  }

  enum Action {
    case search(SearchFeature.Action)
  }

  var body: some Reducer <State, Action> {
    Scope(state: \.search, action: \.search) {
      SearchFeature()
    }
  }
}
