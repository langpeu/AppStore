//
//  EditNameReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditNameReducer {
    @ObservableState
    struct State {
        var name: String
        
        @Presents var alert: AlertState<Action.AlertAction>? //nil 이면 사라짐, nil 아니면 뜸
    }
    
    enum Action {
        case inputName(String)
        case clearText
        case onEditFail(String)
        case onEditSuccess(String)
        case showAlert(String)
        case alert(PresentationAction<AlertAction>)
        
        enum AlertAction {
            // aleart action
        }
    }
    
    var body: some Reducer <State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputName(name):
                state.name = name
                return .none
            case .clearText:
                state.name = ""
                return .none
            case let .onEditFail(message):
                //TODO: alert
                return .send(.showAlert(message))
            case let .showAlert(message):
                state.alert = .init(title: {
                    TextState("에러")
                }, actions: {
                    ButtonState {
                        TextState("확인")
                    }
                }, message: {
                    TextState("에러가 발생했습니다 \(message)")
                })
                return .none
            case .onEditSuccess:
                return .none
            case let .alert(presentationAction):
                switch presentationAction {
                case .dismiss:
                    state.alert = nil
                    return .none
                case let .presented(action):
                    //TODO action 처리
                    return .none
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    private var user: User? {
        users.first
    }
    
    var body: some View {
        VStack {
            Text("이름을 입력해 주세요")
            TextField("이름을 입력해주세요", text: $store.name.sending(\.inputName))
            //        TextField("이름을 입력해주세요", text:Binding(get: {
            //            store.name
            //        }, set: { name in
            //            store.send(.inputName(name))
            //        }))
                .padding(.trailing, 32)
                .overlay(alignment: .topTrailing) {
                    if !store.name.isEmpty {
                        Button {
                            store.send(.clearText)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                }
                .submitLabel(.done)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onSubmit {
                    editName(name: store.name)
                }
        }
        .padding(30)
        .alert($store.scope(state: \.alert, action: \.alert))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //submit
                    editName(name: store.name)
                } label: {
                    Text("저장")
                }
            }
        }
    }
    
    func editName(name: String) {
        guard !name.isEmpty else {
            store.send(.onEditFail("이름을 입력해주세요."))
            return
        }
        
        user?.name = name
        
        do {
            try context.save()
            store.send(.onEditSuccess(name))
        } catch let error {
            store.send(.onEditFail(error.localizedDescription))
        }
    }
}

#Preview {
    EditNameView(
        store: Store(initialState: EditNameReducer.State(name: "홍길동")) {
            EditNameReducer()
        }
    )
}

