//
//  SearchResultReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import ComposableArchitecture
import SwiftUI
import Dependencies

@Reducer
struct SearchResultFeature {
    @Dependency(\.appStoreClient) var client
    @ObservableState
    struct State {
        let keyword: String
        var list: IdentifiedArrayOf<AppListItem> = []
        @Presents var alert: AlertState<Action>?
    }
    
    enum Action {
        case search
        case searchResponse(TaskResult<[AppListItem]>)
        case alert(PresentationAction<Action>)
    }
    
    enum CancelID: String {
        case search
    }
    
    var body: some Reducer <State, Action > {
        Reduce { state, action in
            switch action {
            case .search:
                return fetchList(keyword: state.keyword)
            case let .searchResponse(.success(appList)):
                state.list.append(contentsOf: appList)
            case let .searchResponse(.failure(error)):
                state.alert = .creatAlert(type: .error(message: "잠시후 다시 시도해주세요"))
            case let .alert(action):
                return .none
            }
            return .none
        }
    }
    
    func fetchList(keyword: String) -> Effect<Action> {
        //TODO: fetch List
        Effect.run { send in
            let result = await client.fetchAppList(keyword, 20)
            switch result {
            case .success(let list):
                await send(.searchResponse(.success(list)))
            case .failure(let error):
                await send(.searchResponse(.failure(error)))
            }
        }
        .debounce(id: CancelID.search, for: 0.5, scheduler: DispatchQueue.main)
        .cancellable(id: CancelID.search, cancelInFlight: true)
    }
}
