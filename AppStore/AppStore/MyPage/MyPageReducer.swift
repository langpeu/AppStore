//
//  MyPageReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/23/25.
//

// Action,State 는 Reducer 내부에 위치함

import ComposableArchitecture


@Reducer
struct MyPageStackReducer {
    @ObservableState
    enum State {
        case name(EditNameReducer.State) // 이름 변경 페이지 리듀서 상태값
        case email(EditEmailReducer.State) // 이메일 변경 페이지 리듀서 상태값
        case image(EditImageReducer.State) // 프로필이미지 변경 페이지 리듀서 상태값
    }
    
    enum Action {
        case name(EditNameReducer.Action) // 이름 변경 페이지 리듀서 액션
        case email(EditEmailReducer.Action) // 이메일 변경 페이지 리듀서 액션
        case image(EditImageReducer.Action) // 프로필이미지 변경 페이지 리듀서 액션
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.name, action: \.name) {
            EditNameReducer()
        }
        
        Scope(state: \.email, action: \.email) {
            EditEmailReducer()
        }
        
        Scope(state: \.image, action: \.image) {
            EditImageReducer()
        }
    }
    
}


@Reducer
struct MyPageReducer: Reducer {
    
    @ObservableState
    struct State {
        var path: StackState<MyPageStackReducer.State> = .init()
        var userName: String = ""
        var userEmail: String = ""
    }
    
    enum Action {
        case onAppear(User)
        case path(StackActionOf<MyPageStackReducer>)
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
                    default : return .none
                    }
                default : return .none
                }
                return Effect.none
            }
        }
        .forEach(\.path, action: \.path) {
            MyPageStackReducer()
        }
    }
}
