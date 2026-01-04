//
//  MyPageFeature.swift
//  AppStore
//
//  Created by Langpeu on 12/23/25.
//

// Action,State 는 Reducer 내부에 위치함

import ComposableArchitecture
import Foundation

@Reducer
struct MyPageStackFeature {
    @ObservableState
    enum State {
        case name(EditNameFeature.State) // 이름 변경 페이지 리듀서 상태값
        case email(EditEmailFeature.State) // 이메일 변경 페이지 리듀서 상태값
        case image(EditImageFeature.State) // 프로필이미지 변경 페이지 리듀서 상태값
    }
    
    enum Action {
        case name(EditNameFeature.Action) // 이름 변경 페이지 리듀서 액션
        case email(EditEmailFeature.Action) // 이메일 변경 페이지 리듀서 액션
        case image(EditImageFeature.Action) // 프로필이미지 변경 페이지 리듀서 액션
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.name, action: \.name) {
            EditNameFeature()
        }
        
        Scope(state: \.email, action: \.email) {
            EditEmailFeature()
        }
        
        Scope(state: \.image, action: \.image) {
            EditImageFeature()
        }
    }
    
}


@Reducer
struct MyPageFeature: Reducer {
    
    @ObservableState
    struct State {
        var path: StackState<MyPageStackFeature.State> = .init()
        var userName: String = ""
        var userEmail: String = ""
        var userImage: Data? = nil
    }
    
    enum Action {
        case onAppear(User)
        case path(StackActionOf<MyPageStackFeature>)
        case tapOption(MyPageOption)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onAppear(user):
                state.userName = user.name
                state.userEmail = user.email
                return Effect.none
                
            case let .tapOption(option):
                switch option {
                case .name:
                    state.path.append(.name(.init(name: state.userName)))
                case .email:
                    state.path.append(.email(.init(email: state.userEmail)))
                case .image:
                    state.path.append(.image(.init()))
                }
                return Effect.none
            case let .path(stackAction):
                switch stackAction {
                case let .element(id, action):
                    switch action {
                    case let .name(.onEditSuccess(name)):
                        state.userName = name
                        state.path.pop(from: id)
                    case let .email(.onEditSuccess(email)):
                        state.userEmail = email
                        state.path.pop(from: id)
//                    case let .image(.onEditSuccess(data)):
//                        state.userImage = data
//                        state.path.pop(from: id)
                    default : return .none
                    }
                default : return .none
                }
                return Effect.none
            }
        }
        .forEach(\.path, action: \.path) {
            MyPageStackFeature()
        }
    }
}
