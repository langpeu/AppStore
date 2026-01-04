//
//  AppView.swift
//  AppStore
//
//  Created by Langpeu on 1/4/26.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    SearchView(
      store: store.scope(
        state: \.search,
        action: \.search
      )
    )
  }
}
