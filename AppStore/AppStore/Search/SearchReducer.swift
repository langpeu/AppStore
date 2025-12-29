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
        var result: SearchResultReducer.State?
    }
    
    enum Action {
        case inputText(String)
        case clearText
        case onTapMyPage
        case onEmptyText
        case onTapKeyword(String)
        case myPage(PresentationAction<MyPageReducer.Action>)
        case result(SearchResultReducer.Action)
        case onSubmit
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputText(text):
                state.keyword = text
                if text.isEmpty {
                    return .send(.onEmptyText)
                }
            case .clearText:
                state.keyword = ""
                return .send(.onEmptyText)
            case .onEmptyText:
                state.result = nil
            case .onTapMyPage:
                state.myPage = .init()
            case .onSubmit:
                state.result = .init()
            case let .onTapKeyword(keyword):
                state.keyword = keyword
                return .send(.onSubmit)
            case let .result(resultAction):
                switch resultAction {
                }
            case let .myPage(myPagePresentationAction):
                switch myPagePresentationAction {
                case let .presented(myPageAction):
                    return .none
                case .dismiss:
                    state.myPage = nil
                    return .none
                }
            }
            
            return .none
        }
        .ifLet(\.$myPage, action: \.myPage) {
            MyPageReducer()
        }
        .ifLet(\.result, action: \.result) {
            SearchResultReducer()
        }
    }
    
}
