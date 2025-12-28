//
//  EditImageReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditImageReducer {
    
    @ObservableState
    struct State {
        var image: Image?
        @Presents var alert: AlertState<Action>?
        
    }
    
    enum Action {
        case onAppear
        case authResult(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return Effect.run { send in
                    let isAuth = await PhotoManager.requestAuthorization()
                    await send(.authResult(isAuth))
                }
            case let .authResult(isAuth):
                if isAuth {
                    let asset = PhotoManager.getAssets()
                } else {
                    state.alert = AlertState.creatAlert(type: .error(message: "권한이 없습니다"))
                }
            }
            return .none
        }
    }
}

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    
    var body: some View {
        Text("EditImageView")
            .onAppear() {
                store.send(.onAppear)
            }
    }
    
}
