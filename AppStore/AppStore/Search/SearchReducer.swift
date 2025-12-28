//
//  SearchReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//

import ComposableArchitecture


@Reducer
struct SearchReducer {
    @ObservableState
    struct State {
        var keyword: String = ""
    }
    
    enum Action {
        case inputText(String)
        case clearText
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputText(text):
                state.keyword = text
            case .clearText:
                state.keyword = ""
            }
            
            return .none
        }
    }
    
}
