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
        
        @Presents var myPage: MyPageReducer.State?
    }
    
    enum Action {
        case inputText(String)
        case clearText
        case onTapMyPage
        
        case myPage(PresentationAction<MyPageReducer.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputText(text):
                state.keyword = text
            case .clearText:
                state.keyword = ""
            case let .myPage(myPagePresentationAction):
                switch myPagePresentationAction {
                case let .presented(myPageAction):
                    return .none
                case .dismiss:
                    state.myPage = nil
                    return .none
                }
            case .onTapMyPage:
                state.myPage = .init()
            }
            
            return .none
        }
        .ifLet(\.$myPage, action: \.myPage) {
            MyPageReducer()
        }
    }
    
}
