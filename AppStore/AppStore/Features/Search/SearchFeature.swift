//
//  SearchReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//

import ComposableArchitecture


@Reducer
struct SearchFeature {
    @ObservableState
    struct State {
        var keyword: String = ""
        
        @Presents var myPage: MyPageFeature.State?
        var result: SearchResultFeature.State?
    }
    
    enum Action {
        case inputText(String)
        case clearText
        case onTapMyPage
        case onEmptyText
        case onTapKeyword(String)
        case myPage(PresentationAction<MyPageFeature.Action>)
        case result(SearchResultFeature.Action)
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
                state.result = .init(keyword: state.keyword)
                return .send(.result(.search))
            case let .onTapKeyword(keyword):
                state.keyword = keyword
                return .send(.onSubmit)
            case let .result(resultAction):
                return .none
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
            MyPageFeature()
        }
        .ifLet(\.result, action: \.result) {
            SearchResultFeature()
        }
    }
    
}
