//
//  EditImageReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI
import SwiftData
import Photos

@Reducer
struct EditImageReducer {
    
    @ObservableState
    struct State {
        var userImage: Image?
        var assets: [PHAsset] = []
        @Presents var alert: AlertState<Action>?
        
    }
    
    enum Action {
        case onAppear(image: Data?)
        case setUserImageData(Data?)
        case setUserImage(Image)
        case authResult(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onAppear(imageData):
                return Effect.run { send in
                    let isAuth = await PhotoManager.requestAuthorization()
                    await send(.authResult(isAuth))
                    await send(.setUserImageData(imageData))
                }
            case let .authResult(isAuth):
                if isAuth {
                    let assets = PhotoManager.getAssets()
                    state.assets = assets
                } else {
                    state.alert = AlertState.creatAlert(type: .error(message: "권한이 없습니다"))
                }
            case let .setUserImageData(data):
                guard let data, let uiImage = UIImage(data: data) else {
                    return .none
                }
                return .send(.setUserImage(Image(uiImage: uiImage)))
                
            case let .setUserImage(image):
                state.userImage = image
                return .none
            }
            return .none
        }
    }
}

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    let colums: [GridItem] = .init(repeating: .init(.flexible()), count: 3)
    
    @Query private var users: [User]
    private var user: User? {
        users.first
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("선택된 이미지")
                // 선택된 이미지
                Group {
                    if let image = store.userImage {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(8)
            }
            
            LazyVGrid(columns: colums, spacing: 10) {
                ForEach(store.assets, id: \.localIdentifier) { asset in
                    AssetImageView(asset: asset, isSelected: false, onTap: { data in
                        //TODO: onTap
                    })
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(8)
        }
        .onAppear() {
            store.send(.onAppear(image: user?.imageData))
        }
    }
    
}


private struct AssetImageView: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: (Data) -> Void
    let imageWidth: CGFloat = (UIScreen.currentWidth - 16 - 20) / 3
    
    @State private var image: Image? = nil
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .frame(width: imageWidth, height: imageWidth)
        .onAppear() {
            PhotoManager.fetchImage(asset: asset) { uiImage in
                guard let uiImage else { return }
                image = Image(uiImage: uiImage)
            }
        }
    }
}
