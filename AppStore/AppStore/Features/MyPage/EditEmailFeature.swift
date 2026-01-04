//
//  EditEmailReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditEmailFeature {
    @ObservableState
    struct State {
        var email: String
        
        @Presents var alert: AlertState<Action.AlertAction>?
    }
    
    enum Action {
        case inputEmail(String)
        case clearText
        case onEditFail(String)
        case onEditSuccess(String)
        case showAlert(String)
        case alert(PresentationAction<AlertAction>)
        
        enum AlertAction {
            
        }
    }
    
    var body : some Reducer <State, Action> {
        Reduce { state, action in
            switch action {
            case let .inputEmail(email):
                state.email = email
                return .none
            case .clearText:
                state.email = ""
                return .none
            case let .onEditFail(message):
                return .send(.showAlert(message))
            case .onEditSuccess:
                return .none
            case let .showAlert(message):
                state.alert = .init(title: {
                    TextState("에러")
                }, actions: {
                    ButtonState {
                        TextState("확인")
                    }
                }, message: {
                    TextState("에러가 발생했습니다. \(message)")
                })
                return .none
            case let .alert(presentationAction):
                switch presentationAction {
                case .dismiss:
                    state.alert = nil
                    return .none
                case let .presented(action):
                    return .none
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct EditEmailView: View {
    @Bindable var store: StoreOf<EditEmailFeature>
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    private var user: User? {
        users.first
    }
    
    var body: some View {
        VStack {
            Text("이메일을 입력해 주세요.")
            TextField("이메일을 입력해주세요", text: $store.email.sending(\.inputEmail))
//            TextField("이메일을 입력해주세요", text: Binding(get: {
//                store.email
//            }, set: { email in
//                store.send(.inputEmail(email))
//            }))
            .padding(.trailing, 30)
            .overlay(alignment: .topTrailing) {
                if !store.email.isEmpty {
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
                editEmail(email: store.email)
            }
        }
        .padding(30)
        .alert($store.scope(state: \.alert, action: \.alert))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editEmail(email: store.email)
                } label: {
                    Text("저장")
                }

            }
        }
    }
    
    func editEmail(email: String) {
        guard !email.isEmpty else {
            store.send(.onEditFail("이메일을 입력해주세요."))
            return
        }
        
        user?.email = email
        
        do {
            try context.save()
            store.send(.onEditSuccess(email))
        } catch let error {
            store.send(.onEditFail(error.localizedDescription))
        }
        
    }
}

#Preview {
    EditEmailView(
        store: Store(initialState: EditEmailFeature.State(email: "icopy@naver.com")) {
            EditEmailFeature()
        }
    )
}
