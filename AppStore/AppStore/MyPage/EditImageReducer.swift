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
        var selectedPhoto: (id: String, data: Data)?
        @Presents var alert: AlertState<Action>?
        
    }
    
    enum Action {
        case onAppear(image: Data?)
        case setUserImageData(Data?)
        case setUserImage(Image)
        case authResult(Bool)
        case onSelectPhoto(id: String, data: Data)
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
            case let .onSelectPhoto(id, data):
                state.selectedPhoto = (id: id, data: data)
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
                    assetCell(asset)
                }
            }
            .padding(8)
        }
        .onAppear() {
            store.send(.onAppear(image: user?.imageData))
        }
    }
    
    @ViewBuilder
    private func assetCell(_ asset: PHAsset) -> some View {
        let isSelectedImage = (store.selectedPhoto?.id == asset.localIdentifier)
        AssetImageView(
            asset: asset,
            isSelected: isSelectedImage,
            onTap: { data in
                store.send(.onSelectPhoto(id: asset.localIdentifier, data: data))
            })
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
}


private struct AssetImageView: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: (Data) -> Void
    let imageWidth: CGFloat = (UIScreen.currentWidth - 16 - 20) / 3
    
    @State private var uiImage: UIImage? = nil
    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .onTapGesture {
                        if let data = uiImage.jpegData(compressionQuality: 1.0) {
                            onTap(data)
                        }
                    }
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .frame(width: imageWidth, height: imageWidth)
        .overlay(alignment: .topTrailing, content: {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .frame(width: 20, height: 20)
            }
        })
        .onAppear() {
            PhotoManager.fetchImage(asset: asset) { uiImage in
                self.uiImage = uiImage
            }
        }
    }
}
