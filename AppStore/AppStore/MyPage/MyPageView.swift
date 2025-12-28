//
//  MyPageView.swift
//  AppStore
//
//  Created by Langpeu on 12/20/25.
//

import SwiftUI
import Alamofire
import ComposableArchitecture
import SwiftData

// 이름변경,이메일변경, 이미지변경
enum MyPageOption: CaseIterable {
    case name
    case email
    case image
    
    var title: String {
        switch self {
        case .name:
            "이름"
        case .email:
            "이메일"
        case .image:
            "프로필 이미지"
        }
    }
}


struct MyPageView: View {
    @Bindable var store: StoreOf<MyPageReducer>
    //@Bindable var store: Store<MyPageReducer.State, MyPageReducer.Action>
    //위에 코드를 짧게 만든 형태
    
    @Query var users: [User]
    var firstUser: User? {
        users.first
    }
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    ForEach(MyPageOption.allCases, id: \.self) { option in
                        let subtitle = switch option {
                        case .name: firstUser?.name ?? ""
                        case .email: firstUser?.email ?? ""
                        case .image: ""
                        }
                        listItem(option: option, subtitle: subtitle)
                    }
                }
            }
            .onAppear {
                guard let firstUser else { return }
                store.send(.onAppear(firstUser))
            }
        } destination: { store in //MyPageStackReducer 이다
            switch store.state {
            case let .name(state):
                if let store = store.scope(state: \.name, action: \.name) {
                    EditNameView(store: store)
                }
            case let .email(state):
                if let store = store.scope(state: \.email, action: \.email) {
                    EditEmailView(store: store)
                }
            case let .image(state):
                if let store = store.scope(state: \.image, action: \.image) {
                    EditImageView(store: store)
                }
            }
            
        }
    }
    
    func listItem(option: MyPageOption, subtitle: String) -> some View {
        Button {
            //TODO: 버튼 클릭 액션
            store.send(.tapOption(option))
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .bold))
                    Text(subtitle)
                        .foregroundStyle(Color(UIColor.lightGray))
                        .font(.system(size: 16))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(UIColor.darkGray))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
}

//#Preview {
//    MyPageView(store: Store(initialState: MyPageReducer.State(), reducer: { MyPageReducer() }))
//}
